library(cagedExplorer)
library(tidyverse)

# Reading monthly data --------------------------------------------------------
df_caged <- map(.x = 1:5,
    .f = ~ str_c('data/sp-2020-0', .x, '.rds') %>% 
      readRDS() %>% 
      mutate(mes = .x)) %>% 
  bind_rows()

# Cleaning and joining additional ---------------------------------------------
df_caged_clean <- df_caged %>% 
  select(
    mes, codigo = codigo_municipio, cnae_secao,
    cnae_subclasse, salario, movimento
  ) %>% 
  mutate(
    mes_nome = as_factor(mes) %>% 
      fct_recode(Jan = '1', Fev = '2', Mar = '3', Abr = '4', Maio = '5'),
    cnae_classe = str_remove(cnae_subclasse, '\\d{2}$') %>% as.numeric()
  ) %>% 
  left_join(
    municipios_sp %>%
      select(Codmun7, codigo, municipio, municipio_clean, pop,
             regiao_administrativa, regiao_governo, regiao_metropolitana),
    by = 'codigo'
  ) %>% 
  select(mes, mes_nome, Codmun7, codigo, municipio:regiao_metropolitana,
         salario, movimento, cnae_secao, codigo_cnae_classe = cnae_classe,
         codigo_cnae_subclasse = cnae_subclasse) %>% 
  left_join(cnae_classes %>% 
              rename(cnae_classe = classe_cnae),
            by = c('codigo_cnae_classe' = 'codigo'))

df_caged_clean %>% 
  saveRDS('data/caged-sp-jan-a-maio-2020.rds')

df_caged_clean %>% 
  write_excel_csv2('data/caged-sp-jan-a-maio-2020.csv')

# Computing employment creation/destrution balance ----------------------------
df_caged_clean %>% 
  group_by(mes) %>% 
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-mensal-estado.csv')

df_caged_clean %>% 
  group_by(mes, regiao_governo, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-mensal-regiao-governo.csv')

df_caged_clean %>% 
  group_by(mes, regiao_administrativa, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-mensal-regiao-administrativa.csv')

df_caged_clean %>% 
  group_by(cnae_classe, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-cnae-estado.csv')
  
df_caged_clean %>% 
  group_by(mes, cnae_classe, .drop = FALSE) %>% 
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-mensal-cnae-estado.csv')

df_caged_clean %>% 
  group_by(mes, cnae_classe, regiao_governo, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-mensal-cnae-regiao-governo.csv')

df_caged_clean %>% 
  group_by(mes, cnae_classe, regiao_administrativa, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-mensal-cnae-regiao-administrativa.csv')

df_caged_clean %>% 
  group_by(cnae_classe, regiao_governo, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-cnae-regiao-governo.csv')

df_caged_clean %>% 
  group_by(cnae_classe, regiao_administrativa, .drop = FALSE) %>%
  summarise(saldo = sum(movimento)) %>% 
  write_excel_csv2('data/saldo-cnae-regiao-administrativa.csv')

