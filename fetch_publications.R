# ==============================================================================
# Fetch Publications from Google Scholar / ORCID → BibTeX
# ==============================================================================

# Dependências
if (!requireNamespace("scholar", quietly = TRUE)) install.packages("scholar")
if (!requireNamespace("RefManageR", quietly = TRUE)) install.packages("RefManageR")
if (!requireNamespace("rorcid", quietly = TRUE)) install.packages("rorcid")
if (!requireNamespace("rcrossref", quietly = TRUE)) install.packages("rcrossref")

library(scholar)
library(RefManageR)
library(dplyr)
library(stringr)

# ==============================================================================
# CONFIGURAÇÃO - EDITE AQUI
# ==============================================================================

# Google Scholar ID (extraído da URL do seu perfil)
# Ex: https://scholar.google.com/citations?user=XXXXXX → XXXXXX
GOOGLE_SCHOLAR_ID <- "essj6yQAAAAJ"

# ORCID (opcional, para metadados mais completos)
ORCID_ID <- "0000-0003-2907-8338"  # Substitua pelo seu ORCID real

# Arquivo de saída
OUTPUT_BIB <- "publications.bib"

# ==============================================================================
# OPÇÃO 1: Google Scholar (mais completo, mas sem DOI)
# ==============================================================================

fetch_from_scholar <- function(scholar_id, max_pubs = 100) {
  message("Fetching publications from Google Scholar...")
  
  pubs <- tryCatch(
    get_publications(scholar_id) |>
      head(max_pubs) |>
      arrange(desc(year)),
    error = function(e) {
      warning("Failed to fetch from Google Scholar: ", e$message)
      return(NULL)
    }
  )
  
  if (is.null(pubs) || nrow(pubs) == 0) {
    warning("No publications found")
    return(NULL)
  }
  
  message(sprintf("Found %d publications", nrow(pubs)))
  return(pubs)
}

scholar_to_bibtex <- function(pubs, output_file = "publications.bib") {
  if (is.null(pubs)) return(invisible(NULL))
  
  # Gerar BibTeX entries
  bib_entries <- pubs |>
    mutate(
      # Criar chave única
      key = paste0(
        str_extract(author, "^[A-Za-z]+") |> tolower(),
        year,
        str_extract(title, "^[A-Za-z]+") |> tolower()
      ),
      # Formatar entrada BibTeX
      bibtex = sprintf(
        '@article{%s,
  author = {%s},
  title = {%s},
  journal = {%s},
  year = {%s},
  number = {%s}
}',
        key,
        author,
        title,
        journal,
        year,
        ifelse(is.na(number), "", number)
      )
    )
  
  # Escrever arquivo
  writeLines(
    paste(bib_entries$bibtex, collapse = "\n\n"),
    output_file
  )
  
  message(sprintf("Saved %d entries to %s", nrow(bib_entries), output_file))
  return(invisible(bib_entries))
}

# ==============================================================================
# OPÇÃO 2: ORCID (metadados melhores, com DOI)
# ==============================================================================

fetch_from_orcid <- function(orcid_id) {
  message("Fetching publications from ORCID...")
  
  # Requer configuração de token para acesso completo
  # Veja: https://docs.ropensci.org/rorcid/
  
  works <- tryCatch({
    rorcid::orcid_works(orcid_id)[[1]]$works
  }, error = function(e) {
    warning("Failed to fetch from ORCID: ", e$message)
    return(NULL)
  })
  
  if (is.null(works) || nrow(works) == 0) {
    warning("No works found in ORCID")
    return(NULL)
  }
  
  message(sprintf("Found %d works in ORCID", nrow(works)))
  return(works)
}

# ==============================================================================
# OPÇÃO 3: DOI → BibTeX (mais preciso)
# ==============================================================================

doi_to_bibtex <- function(dois, output_file = "publications.bib") {
  message("Converting DOIs to BibTeX...")
  
  bib_list <- lapply(dois, function(doi) {
    tryCatch({
      rcrossref::cr_cn(dois = doi, format = "bibtex")
    }, error = function(e) {
      warning(sprintf("Failed to fetch DOI %s: %s", doi, e$message))
      return(NULL)
    })
  })
  
  bib_entries <- Filter(Negate(is.null), bib_list)
  
  if (length(bib_entries) > 0) {
    writeLines(unlist(bib_entries), output_file)
    message(sprintf("Saved %d entries to %s", length(bib_entries), output_file))
  }
  
  return(invisible(bib_entries))
}

# ==============================================================================
# MAIN: Execute fetch
# ==============================================================================

fetch_all_publications <- function(
    scholar_id = GOOGLE_SCHOLAR_ID,
    orcid_id = ORCID_ID,
    output_file = OUTPUT_BIB,
    source = c("scholar", "orcid", "manual")
) {
  source <- match.arg(source)
  
  if (source == "scholar" && !is.null(scholar_id) && scholar_id != "") {
    pubs <- fetch_from_scholar(scholar_id)
    scholar_to_bibtex(pubs, output_file)
    
  } else if (source == "orcid" && !is.null(orcid_id) && orcid_id != "") {
    works <- fetch_from_orcid(orcid_id)
    # Processar works do ORCID...
    
  } else {
    message("Using manual publications.bib file")
  }
  
  message("Done! Publications saved to: ", output_file)
}

# ==============================================================================
# Executar (descomente a linha desejada)
# ==============================================================================

# Buscar do Google Scholar:
# fetch_all_publications(source = "scholar")

# Buscar do ORCID:
# fetch_all_publications(source = "orcid")

# Usar arquivo .bib manual:
# fetch_all_publications(source = "manual")

# ==============================================================================
# Exemplo de uso com DOIs específicos
# ==============================================================================

# Se você tem DOIs das suas publicações, esta é a forma mais precisa:
# 
# meus_dois <- c(
#   "10.1590/1678-4685e20220157",
#   "10.1080/09505431.2022.2062404",
#   "10.1186/s40337-022-00616-8"
# )
# doi_to_bibtex(meus_dois, "publications.bib")
