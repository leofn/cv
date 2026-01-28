# CV Acadêmico - Leonardo F. Nascimento

CV acadêmico reprodutível em **Quarto** com integração automática de publicações via Google Scholar/ORCID.

## 🚀 Quick Start

```bash
# 1. Clone e entre no diretório
git clone https://github.com/leofn/cv.git && cd cv

# 2. Baixe o CSL para formatação APA (obrigatório)
curl -sL "https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl" -o apa.csl

# 3. Instale dependências R
Rscript -e 'install.packages(c("dplyr", "knitr", "glue", "scholar", "RefManageR"))'

# 4. Renderize
quarto render cv_leonardo_nascimento.qmd
```

## 📁 Estrutura

```
├── cv_leonardo_nascimento.qmd   # Fonte do CV (Quarto)
├── publications.bib              # Publicações em BibTeX
├── fetch_publications.R          # Script para buscar publicações
├── styles.css                    # Estilos customizados
├── apa.csl                       # Estilo de citação (baixar separado)
├── _site/                        # Output renderizado
└── .github/workflows/render.yml  # CI/CD automático
```

## 📚 Gerenciamento de Publicações

### Opção 1: Google Scholar (recomendado)

```r
source("fetch_publications.R")

# Configure seu Google Scholar ID no script, depois:
fetch_all_publications(source = "scholar")
```

Para encontrar seu ID: acesse seu perfil no Google Scholar e copie o valor após `user=` na URL.

### Opção 2: DOIs diretos (mais preciso)

```r
source("fetch_publications.R")

meus_dois <- c(
  "10.1590/1678-4685e20220157",
  "10.1080/09505431.2022.2062404"
)
doi_to_bibtex(meus_dois, "publications.bib")
```

### Opção 3: Manual

Edite `publications.bib` diretamente. Formato:

```bibtex
@article{chave2024,
  author = {Sobrenome, Nome},
  title = {Título do Artigo},
  journal = {Nome da Revista},
  year = {2024},
  doi = {10.xxxx/xxxxx}
}
```

## 🌐 Deploy via GitHub Pages

### Setup inicial

1. Push para GitHub:
   ```bash
   git init && git add . && git commit -m "Initial commit"
   gh repo create cv --public --source=. --push
   ```

2. Configure Pages: **Settings → Pages → Source: "GitHub Actions"**

3. Cada push no `.qmd` ou `.bib` triggera rebuild automático

### URLs

- **CV online**: `https://leofn.github.io/cv/`
- **Arquivo fonte**: `https://github.com/leofn/cv`

## ⚙️ Customização

### Temas disponíveis

No YAML header do `.qmd`:

```yaml
format:
  html:
    theme: flatly    # ou: cosmo, journal, lumen, sandstone, simplex, yeti
```

### Estilos de citação

Baixe outros estilos de [citation-style-language/styles](https://github.com/citation-style-language/styles):

```bash
# Chicago
curl -sL "https://raw.githubusercontent.com/citation-style-language/styles/master/chicago-author-date.csl" -o chicago.csl

# ABNT
curl -sL "https://raw.githubusercontent.com/citation-style-language/styles/master/associacao-brasileira-de-normas-tecnicas.csl" -o abnt.csl
```

Atualize o `csl:` no YAML header.

### Multilíngua

Para versão em português, duplique o `.qmd` e traduza. O Quarto suporta múltiplos outputs:

```yaml
# _quarto.yml
project:
  output-dir: _site

format:
  html:
    output-file: index.html
```

## 🔄 Workflow de Atualização

1. Atualize publicações: `Rscript -e "source('fetch_publications.R'); fetch_all_publications(source='scholar')"`
2. Edite o `.qmd` conforme necessário
3. Commit e push → deploy automático

## 📋 Dependências

- [Quarto](https://quarto.org/docs/get-started/) ≥ 1.3
- R ≥ 4.0 com pacotes: `dplyr`, `knitr`, `glue`, `scholar`, `RefManageR`

## 📄 Licença

CC BY 4.0
