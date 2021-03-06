//===- StandardToSPIRVPass.cpp - Standard to SPIR-V Passes ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a pass to convert standard dialect to SPIR-V dialect.
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/StandardToSPIRV/StandardToSPIRVPass.h"
#include "../PassDetail.h"
#include "mlir/Conversion/ArithmeticToSPIRV/ArithmeticToSPIRV.h"
#include "mlir/Conversion/ControlFlowToSPIRV/ControlFlowToSPIRV.h"
#include "mlir/Conversion/MathToSPIRV/MathToSPIRV.h"
#include "mlir/Conversion/StandardToSPIRV/StandardToSPIRV.h"
#include "mlir/Dialect/SPIRV/IR/SPIRVDialect.h"
#include "mlir/Dialect/SPIRV/Transforms/SPIRVConversion.h"

using namespace mlir;

namespace {
/// A pass converting MLIR Standard operations into the SPIR-V dialect.
class ConvertStandardToSPIRVPass
    : public ConvertStandardToSPIRVBase<ConvertStandardToSPIRVPass> {
  void runOnOperation() override;
};
} // namespace

void ConvertStandardToSPIRVPass::runOnOperation() {
  MLIRContext *context = &getContext();
  ModuleOp module = getOperation();

  auto targetAttr = spirv::lookupTargetEnvOrDefault(module);
  std::unique_ptr<ConversionTarget> target =
      SPIRVConversionTarget::get(targetAttr);

  SPIRVTypeConverter::Options options;
  options.emulateNon32BitScalarTypes = this->emulateNon32BitScalarTypes;
  SPIRVTypeConverter typeConverter(targetAttr, options);

  // TODO ArithmeticToSPIRV/ControlFlowToSPIRV cannot be applied separately to
  // StandardToSPIRV
  RewritePatternSet patterns(context);
  arith::populateArithmeticToSPIRVPatterns(typeConverter, patterns);
  cf::populateControlFlowToSPIRVPatterns(typeConverter, patterns);
  populateMathToSPIRVPatterns(typeConverter, patterns);
  populateStandardToSPIRVPatterns(typeConverter, patterns);
  populateTensorToSPIRVPatterns(typeConverter, /*byteCountThreshold=*/64,
                                patterns);
  populateBuiltinFuncToSPIRVPatterns(typeConverter, patterns);

  if (failed(applyPartialConversion(module, *target, std::move(patterns))))
    return signalPassFailure();
}

std::unique_ptr<OperationPass<ModuleOp>>
mlir::createConvertStandardToSPIRVPass() {
  return std::make_unique<ConvertStandardToSPIRVPass>();
}
