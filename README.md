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

# Teste criar imagem local com AutoDock 4.2.6

Buildar imagem:

```
docker build -t autodock:4.2 .
```

Rodar container interativo:

```
docker run -it autodock:4.2 bash
```

Testar comando:

```bash
autodock4
```

Ver se o autogrid também funciona

```bash
autogrid4
```

Crie um arquivo vazio de teste no seu host chamado `test.dpf`:

```bash
touch test.dpf
```

Execute dentro do container

```bash
autodock4 -p test.dpf
```

Vai gerar um arquivo test.dlg, para ver o conteúdo desse arquivo faça

```bash
cat test.dlg
```

# Criando cluster na AWS

Para isso, criei um profile de um usuário da AWS e defini ele como o padrão no meu terminal

```bash
export AWS_PROFILE=profile-criado
```

Em seguida, criei os nós

```bash
eksctl create cluster \
  --name autodock-cluster \
  --region us-east-2 \
  --nodegroup-name autodock-nodes \
  --node-type c7i-flex.large \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
```

Atualizar kubeconfig

```bash
aws eks --region us-east-2 update-kubeconfig --name autodock-cluster
```

Testar acesso

```bash
kubectl get nodes
```

Resultado esperado:

```text
ip-xxx   Ready
ip-yyy   Ready
```

Criar repositório no Amazon ECR

```bash
aws ecr create-repository --repository-name autodock
```

Login no ECR

```bash
aws ecr get-login-password --region us-east-2 | \
docker login --username AWS --password-stdin <SEU_ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com
```

Tag da imagem

```bash
docker tag autodock:4.2 <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/autodock:4.2
```

Push da imagem

```bash
docker push <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/autodock:4.2
```

# Deletar tudo que está sendo descontado na AWS

Apagar cluster

```bash
eksctl delete cluster --name autodock-cluster --region us-east-2
```

Apagar repositório no Amazon ECR

```bash
aws ecr delete-repository \
  --repository-name autodock \
  --region us-east-2 \
  --force
```

--force remove imagens também

Verifique por volumes EBS (raro, mas possível)

```bash
aws ec2 describe-volumes --region us-east-2
```

Se tiver volumes sobrando, delete no console AWS

Verifique também por Elastic IP (se criou manualmente)

```bash
aws ec2 describe-addresses --region us-east-2
```
