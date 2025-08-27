from rdkit import Chem

input_sdf = "raw-ligands-data/nubbedb-08-2025.sdf"
output_sdf = "raw-ligands-data/ligands_with_Hs.sdf"

suppl = Chem.SDMolSupplier(input_sdf, removeHs=False)
writer = Chem.SDWriter(output_sdf)

for mol in suppl:
    if mol is not None:
        mol = Chem.AddHs(mol)
        writer.write(mol)

writer.close()
