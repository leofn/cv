# CV - Leonardo Fernandes Nascimento

CV acadêmico em Quarto com múltiplas bibliografias e contagem automática de publicações.

## 🚀 Deploy Rápido

### Opção 1: GitHub Pages (recomendado)

1. Crie um repositório `cv` no GitHub
2. Copie todos os arquivos deste projeto para o repositório
3. Vá em **Settings > Pages** e selecione **GitHub Actions** como source
4. O workflow vai rodar automaticamente e publicar em `https://SEU_USUARIO.github.io/cv/`

### Opção 2: Render Local

```bash
# Instalar extensão multibib (uma vez)
quarto add pandoc-ext/multibib --no-prompt

# Renderizar
quarto render cv_leonardo_nascimento.qmd
```

## 📁 Estrutura do Projeto

```
cv/
├── cv_leonardo_nascimento.qmd    # CV principal
├── apa-cv.csl                    # Estilo de citação (ordenado por data desc)
├── count-refs.lua                # Lua filter para contagem automática
├── bib/
│   ├── articles.bib              # Artigos em periódicos
│   ├── books.bib                 # Livros
│   ├── chapters.bib              # Capítulos de livros
│   ├── reports.bib               # Relatórios e congressos
│   └── theses.bib                # Teses e dissertações
├── .github/
│   └── workflows/
│       └── publish.yml           # Deploy automático
└── README.md
```

## ✏️ O que você precisa preencher

Busque por estes placeholders no `cv_leonardo_nascimento.qmd`:

| Placeholder | Onde encontrar |
|------------|----------------|
| `SEU_ID_AQUI` (Google Scholar) | URL do seu perfil no Scholar |
| `SEU_ID_AQUI` (Lattes) | ID numérico do Lattes |
| `h-index: **X**` | Google Scholar |
| `Citações: **X**` | Google Scholar |
| Orientações | Seu Lattes/memorial |
| Valores dos projetos | Termos de outorga |
| Seção Supervision | Seus orientandos |
| Seção Academic Service | Bancas, pareceres, etc. |

## 🔧 Como funciona

### Múltiplas Bibliografias

O filtro `multibib` permite separar publicações por tipo:

```yaml
bibliography:
  articles: bib/articles.bib
  books: bib/books.bib
  # ...
```

Cada categoria é renderizada em uma div específica:

```markdown
::: {#refs-articles}
:::
```

### Contagem Automática

O filtro `count-refs.lua` substitui placeholders `{{count:categoria}}` pelo número de entradas:

```markdown
### Peer-Reviewed Articles {{count:articles}}
```

Renderiza como:

```
### Peer-Reviewed Articles (18)
```

### Ordenação por Data

O CSL `apa-cv.csl` ordena as publicações da mais recente para a mais antiga (padrão para CVs acadêmicos).

## ➕ Adicionando Publicações

1. Identifique a categoria (article, book, chapter, report)
2. Adicione a entrada BibTeX no arquivo `.bib` correspondente
3. Commit e push — o GitHub Actions atualiza automaticamente

### Exemplo de entrada

```bibtex
@article{sobrenome2024titulo,
  author = {Sobrenome, Nome and Coautor, Nome},
  title = {Título do artigo},
  journal = {Nome do Periódico},
  year = {2024},
  volume = {10},
  number = {2},
  pages = {100--120},
  doi = {10.xxxx/xxxxx}
}
```

## 🐛 Troubleshooting

### "Unknown citation key"
- Verifique se a chave existe no `.bib` correto
- Verifique sintaxe BibTeX (vírgulas, chaves)

### Bibliografia não aparece
- Confirme que o filtro multibib está instalado
- Verifique se o ID da div corresponde ao nome da bib

### Contagem mostra "(?)"
- O Lua filter não encontrou a categoria
- Verifique se o nome no `{{count:X}}` corresponde ao nome do arquivo `.bib`

### Erro no GitHub Actions
- Verifique se todos os arquivos estão no repositório
- Confira se o workflow tem permissão para Pages

## 📄 Licença

MIT
