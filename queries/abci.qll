import go
import DataFlow

/**
 * This defines the dataflow of Msg functions to the Handler it will be passed onto. 
 * 
 * It uses the fact that the function contains `Msg` in the name (which it normally will if protobuf is used). 
 * In case this is not true, change it here in the `isSink` method.
 */
class MsgConfig extends Configuration {
    MsgConfig() { this = "Cosmos Msg callee flow" }

    override predicate isSource(Node n) {
        n instanceof FunctionNode
    }

    override predicate isSink(Node n) {
        exists(Write w |
            w.writesField(_, any(Field f | f.hasQualifiedName("google.golang.org/grpc", "MethodDesc", "Handler")), n)
        ) and 
        n.toString().matches("%Msg%")
    }
}

/**
 * This defines the dataflow of Query functions to the Handler it will be passed onto. 
 * 
 * It uses the fact that the function contains `Query` in the name (which it normally will if protobuf is used). 
 * In case this is not true, change it here in the `isSink` method.
 */
class QueryConfig extends Configuration {
    QueryConfig() { this = "Cosmos Query callee flow" }

    override predicate isSource(Node n) {
        n instanceof FunctionNode
    }

    override predicate isSink(Node n) {
        exists(Write w |
            w.writesField(_, any(Field f | f.hasQualifiedName("google.golang.org/grpc", "MethodDesc", "Handler")), n)
        ) and 
        n.toString().matches("%Query%")
    }
}

Function getABeginEndBlockFunc() {
    result.getName().matches(["%BeginBlock%", "%EndBlock%"])
}

private FuncDecl reachableFromService(Configuration c) {
    exists(FunctionNode handler | 
        c.hasFlow(handler, _) and
        result = handler.getFunction().getFuncDecl()
    ) or 
    exists(CallNode cn |
        cn.getRoot() = reachableFromService(c) and
        result = cn.getACalleeIncludingExternals().asFunction().getFuncDecl()
    )
}

private FuncDecl reachableFromBEBlock() {
    result = getABeginEndBlockFunc().getFuncDecl()
    or
    exists(CallNode cn |
        cn.getRoot() = reachableFromBEBlock() and
        result = cn.getACalleeIncludingExternals().asFunction().getFuncDecl()
    )
}

/**
 * The declaration of all functions that are in the path of a begin or endblock function
 */
class BeginEndBlockFuncDecl extends ConsensusCriticalFuncDecl {
    BeginEndBlockFuncDecl() {
        this = reachableFromBEBlock()
    }
}


/**
 * The declaration of all functions that are used in a Cosmos message (transaction)
 */
class MsgFuncDecl extends ConsensusCriticalFuncDecl {
    MsgFuncDecl() {
        exists(MsgConfig c |
            this = reachableFromService(c)    
        )
    }
}

/**
 * The declaration of all functions that are used in a Cosmos query
 */
class QueryFuncDecl extends ABCIFuncDecl {
    QueryFuncDecl() {
        exists(QueryConfig c |
            this = reachableFromService(c)    
        )
    }
}

/**
 * The declaration of all functions that are part of ABCI calls
 * 
 * This is currently defined as all functions in Message, Query, or Begin/EndBlock paths
 * 
 * Mock and test packages are explicitly ignored, as sometimes they have dataflow to the actual ABCI methods
 */
abstract class ABCIFuncDecl extends FuncDecl {
    ABCIFuncDecl() {
        not this.getFile().getPackageName().matches(["%mock%", "%test%"])
    }
}

/**
 * The declaration of all functions that are part of consensus critical code.
 * 
 * This is currently defined as all functions in Message or Begin/EndBlock paths
 */
abstract class ConsensusCriticalFuncDecl extends ABCIFuncDecl {

    // Pb files are ignored as they are autogenerated and should not affect consensus
    ConsensusCriticalFuncDecl() {
        not this.getFile().getBaseName().matches("%.pb.%")
    }
}