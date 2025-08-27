## Convertendo arquivo .sdf para .pdbqt

Inicialmente, foi baixado o arquivo nubbedb-08-2025.sdf, com os dados de todas as biomoléculas brasileiras obtidas do NuBBEDB pelo link https://coconut.naturalproducts.net/search?type=tags&q=NuBBEDB&tagType=dataSource&page=1. O arquivo foi salvo na pasta raw-ligands-data, localizado na raiz do diretório.

Em seguida, foi necessário tratar o arquivo .sdf para adicionar as moléculas de hidrogênio (foi preciso para conseguir usar o pacote python Meeko para converter o .sdf para .pdbqt, extensão usada no AutoDock GPU). Para esse tratamento, foi feito um script python que pode ser rodado pelo comando abaixo dado na raiz do diretório:

```
python3 addHs.py 
```

O arquivo gerado pelo script foi usado no comando abaixo para fazer a conversão .sdf para .pdbqt usando Meeko

```
mk_prepare_ligand.py -i ./raw-ligands-data/ligands_with_Hs.sdf --multimol_outdir ligands
```
