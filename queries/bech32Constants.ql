/**
 * @name Directly using the bech32 constants
 * @description Using direct Bech32 constants is not advised. Instead use `sdk.GetConfig().GetBech32...`  and `sdk.GetnConfig().SetBech32...`.
 * See https://github.com/cosmos/cosmos-sdk/pull/8461 and https://github.com/cosmos/cosmos-sdk/pull/9212
 * @kind problem
 * @precision medium
 * @problem.severity warning
 * @id jaspersurmont/bech32-constant
 * @tags correctness
 */

import go
import abci

from Constant cn, ConsensusCriticalFuncDecl f
where
  // Possible improvement: check if the constant is ever passed as an argument to SetBech32Prefix...
  cn.getDeclaration().getName().matches("Bech32%") and cn.getARead().getRoot() = f
select cn, "Directly using the bech32 constants instead of the configuration values"
