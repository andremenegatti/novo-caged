library(tidyverse)

for (i in 1:5) {
  
  txt_file <- str_c('data/raw/CAGEDMOV20200', i, '.txt')
  
  df_caged <-
    read_delim(file = txt_file,
               delim = ";",
               trim_ws = TRUE,
               escape_double = FALSE,
               locale = locale(
                 decimal_mark = ",",
                 grouping_mark = ".",
                 encoding = "ISO-8859-1"
               )
    )
  
  glimpse(df_caged)
  
  names(df_caged) <- c('competencia', 'regiao', 'uf', 'codigo_municipio', 'cnae_secao',
                       'cnae_subclasse', 'movimento', 'categoria', 'cbo2002',
                       'codigo_grau_instrucao', 'idade', 'sexo', 'tipo_empregador',
                       'tipo_estabelecimento', 'tipo_movimentacao',
                       'ind_intermitente', 'ind_parcial', 'salario', 'horas_contrato',
                       'tipo_deficiencia', 'codigo_raca_cor', 'ind_aprendiz', 'fonte')
  
  df_caged <- df_caged %>% 
    mutate(salario = as.numeric(salario))
  
  glimpse(df_caged)
  
  library(cagedExplorer)
  
  df_caged_sp <- df_caged %>% 
    filter(codigo_municipio %in% municipios_sp$codigo)
  
  saveRDS(df_caged_sp,
          str_c('~/Documents/novo-caged/data/sp-2020-0', i, '.rds'))
  
}


