# 🕵️‍♂️ HTML Host Parser — `parsing.sh`

![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white) ![License](https://img.shields.io/badge/license-Educational-blue) ![Desec](https://img.shields.io/badge/NPP-Desec%20Security-yellow)

---

## 📖 Visão Geral

O **`parsing.sh`** é um script desenvolvido como tarefa do **NPP da Desec Security**, no módulo de **Bash Scripting**.\
Sua função é realizar **parsing HTML** em uma página indicada pelo usuário, extraindo todos os **hosts** contidos em links e resolvendo seus respectivos **endereços IP**.

O resultado é salvo em um arquivo no formato:
host=ip

---

## ⚙️ Funcionamento

Ao ser executado, o script:

1. Recebe como argumento uma **URL** (ex: `site.com`).
2. Baixa o conteúdo da página com `wget`.
3. Extrai os **hosts** encontrados nos links (`href`) do HTML.
4. Resolve os **endereços IP** de cada host via comando `host`.
5. Gera um arquivo final `hosts_<URL>` com as correspondências `host=ip`.
6. Limpa os arquivos temporários criados durante a execução.
7. Pergunta ao usuário se deseja repetir o processo para outro site.

---

## 🧩 Código

```
#!/bin/bash
if [ "$1" == "" 2>/dev/null ]
then
	echo -e "\033[1;31m   >>>>> USO CORRETO: ./parsing.sh <url>"
else
	echo -e "\033[1;32m   >>>>> ACESSANDO PÁGINA"
	echo -e "\033[1;37m "
	wget $1 2>/dev/null
	echo -e "\033[1;34m   >>>>> BUSCANDO HOSTS NA PÁGINA" "\033[1;37m "
	grep href index.html | grep http | cut -d "/" -f3 | cut -d '"' -f1  | grep "\." | grep -v " "> lista
	cat lista
	echo -e "\033[1;37m "
	echo -e "\033[1;34m   >>>>> RESOLVENDO HOSTS ENCONTRADOS" "\033[1;37m "
	for url in $(cat lista); do host $url | grep " has address " >> hosts; done
	sed -i 's/ has address /=/g' hosts
	cat hosts | uniq > hosts_$1
	cat hosts_$1
	echo -e "\033[1;37m "
	echo -e "\033[1;33m   >>>>> PRONTO!" "\033[1;32m "
	echo " "
	rm hosts
	rm index.html
	rm lista
	read -p "   >>>>> DESEJA FAZER NOVAMENTE? [y/n] " answer
	if [ "$answer" != "y" ]
	then
		echo -e "\033[1;31m   >>>>> ENCERRADO!" "\033[1;37m "
	else
		read -p "   >>>>> DIGITE A NOVA URL:  " alvo
		echo " "
		./$0 $alvo
	fi
fi
```

---

## 🧠 Uso
Sintaxe:\
`
./parsing.sh <URL>
`

Exemplo:\
`
./parsing.sh example.com
`

Saída esperada:
```
>>>>> ACESSANDO PÁGINA

>>>>> BUSCANDO HOSTS NA PÁGINA
example.com
cdn.example.com

>>>>> RESOLVENDO HOSTS ENCONTRADOS
example.com=93.184.216.34
cdn.example.com=151.101.1.69

>>>>> PRONTO!
```

Arquivo gerado:\
`
hosts_example.com
`

Conteúdo:\
`
example.com=93.184.216.34  
cdn.example.com=151.101.1.69
`

---

## 📦 Requisitos

| Ferramenta           | Descrição                        |
| -------------------- | -------------------------------- |
| `bash`               | Shell para execução              |
| `wget`               | Para baixar a página HTML        |
| `grep`, `cut`, `sed` | Manipulação e filtragem de texto |
| `host`               | Resolução de nomes para IP       |

Permissão de execução
`
chmod +x parsing.sh
`

---

## 📂 Arquivos Criados
| Arquivo       | Função                    | Status   |
| ------------- | ------------------------- | -------- |
| `index.html`  | Página HTML baixada       | Removido |
| `lista`       | Lista de hosts extraídos  | Removido |
| `hosts`       | Saída intermediária       | Removido |
| `hosts_<URL>` | Resultado final (host=ip) | Mantido  |

---

## 👨‍💻 Créditos

Autor: Epke\
Linguagem: Bash\
Função: Parsing de hosts e resolução de IPs\
Categoria: Segurança / Automação

---

## 🧾 Licença

Este script é disponibilizado para fins educacionais e experimentais. O uso em ambientes de produção ou contra domínios sem autorização é estritamente proibido.
