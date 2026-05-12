Sistema de Banco de Dados para Gestão de Creche

Projeto acadêmico de banco de dados relacional completo, desenvolvido com **MySQL**, cobrindo desde a modelagem OLTP até um Data Warehouse OLAP no modelo estrela (Star Schema), com ETL, validação de carga, índices, views, triggers, stored procedures e controle transacional.


-- Visão Geral --

O projeto simula o sistema de dados de uma creche, gerenciando informações de alunos, responsáveis, funcionários, turmas, desempenho acadêmico, frequência, financeiro e RH. 

O banco é dividido em dois ambientes:

- **`creche_db`** — banco transacional (OLTP), responsável pelo dia a dia operacional
- **`creche_dw`** — Data Warehouse (OLAP), estruturado em Star Schema para análises gerenciais

-- Módulos --

### Acadêmico
Gerencia alunos, responsáveis, turmas, disciplinas, matrículas, frequência e desempenho. Inclui suporte a alunos PCD com tabela dedicada e vínculo com CID de doenças.

### RH
Gerencia funcionários, frequência, férias e atestados médicos. Inclui triggers para validação automática de datas de férias e horas trabalhadas.

### Financeiro
Controla a folha de pagamento dos funcionários com salário base, hora extra, descontos e benefícios.

### Data Warehouse (OLAP)
Star Schema com dimensões de tempo, aluno, funcionário, turma, disciplina, responsável, doença, perfil PCD e local. Tabelas fato cobrem matrícula, desempenho, frequência, financeiro, férias e atestados.

---

## 🛠️ Tecnologias

- **MySQL** (compatível com versão 5.7+)
- SQL puro — sem dependências externas
- Modelagem OLTP + OLAP (Star Schema)
- ETL via `INSERT ... SELECT` entre bancos

---

## ▶️ Como Executar

### Pré-requisitos
- MySQL Server instalado (recomendado: MySQL 5.7 ou superior)
- Cliente MySQL (MySQL Workbench, DBeaver, terminal, etc.)

### Passos

1. Abra o arquivo principal (run_all_sql) no seu cliente MySQL:

2. Execute o script completo.

## 🧩 Objetos do Banco

### Índices
Criados em colunas de filtro frequente (nome, cargo, status, data, chaves estrangeiras) tanto no OLTP quanto no DW, otimizando `JOIN` e `WHERE`.

### Views (DW)

| `vw_media_alunos` | Média geral de notas por aluno |
| `vw_frequencia_alunos` | Total de presenças por aluno |
| `vw_desempenho_disciplinas` | Média de notas por disciplina |
| `vw_custos_rh` | Composição salarial por funcionário |
| `vw_ferias_funcionarios` | Dias e status de férias por funcionário |

### Triggers

| `trg_log_matricula` | AFTER INSERT em `tb_matricula` | Registra toda nova matrícula em `tb_log_matriculas` |
| `trg_verificar_capacidade_turma` | BEFORE INSERT em `tb_matricula` | Bloqueia matrícula se turma estiver lotada |
| `trg_validar_horas_funcionario` | BEFORE INSERT em `tb_frequencia_funcionario` | Rejeita horas trabalhadas acima de 24h |
| `trg_calcular_retorno_ferias` | BEFORE INSERT em `tb_ferias` | Define `data_retorno` automaticamente como `data_fim + 1 dia` |
| `trg_validar_datas_ferias` | BEFORE INSERT em `tb_ferias` | Rejeita `data_fim` menor que `data_inicio` |

### Stored Procedures

| `sp_realizar_matricula(aluno, turma)` | Insere matrícula com data atual e status Ativa |
| `sp_media_aluno(aluno)` | Retorna a média de notas de um aluno específico |
| `sp_relatorio_rh()` | Retorna relatório completo da folha de pagamento |

### Controle Transacional
O script inclui cenários de teste de transação para demonstração didática:
- **Cenário 1** — INSERT com ROLLBACK (registro não deve persistir)
- **Cenário 2** — INSERT com COMMIT (registro deve persistir)
- **Cenário 3** — Múltiplas operações com ROLLBACK (nenhuma deve persistir)

---

## ♻️ Idempotência

O script foi projetado para ser executado múltiplas vezes sem erros, seguindo estas estratégias:

- `DROP DATABASE IF EXISTS` no início garante ambiente limpo a cada execução
- `CREATE DATABASE IF NOT EXISTS` para ambos os bancos
- `INSERT IGNORE INTO` em todas as tabelas fato e dimensão do DW, evitando duplicatas em caso de reexecução parcial
- Triggers, procedures e views são recriados junto com o banco, sem conflito

> A idempotência aqui é do tipo **destrutiva controlada**: adequada para desenvolvimento e ambiente acadêmico. Em produção, o `DROP DATABASE` seria substituído por migrations versionadas.

---

Desenvolvido como projeto acadêmico para a matéria de Banco de Dados