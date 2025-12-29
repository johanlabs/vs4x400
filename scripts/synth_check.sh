#!/bin/bash
# Script simples para verificar se o código é sintetizável usando Icarus
echo "Verificando sintaxe para síntese..."
iverilog -t null rtl/vector_k_core.v rtl/vector_k_axi.v
if [ $? -eq 0 ]; then
    echo "✅ Código validado para síntese!"
else
    echo "❌ Erros encontrados."
fi