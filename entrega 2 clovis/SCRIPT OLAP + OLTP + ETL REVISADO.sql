DROP DATABASE IF EXISTS creche_dw;
DROP DATABASE IF EXISTS creche_db;


/* ============================================================
   OLTP
   ============================================================ */

CREATE DATABASE creche_db;
USE creche_db;


/* ============================================================
   TABELAS AUXILIARES
   ============================================================ */

CREATE TABLE sexo_enum (
    id INT PRIMARY KEY,
    descricao VARCHAR(20)
);

INSERT INTO sexo_enum VALUES
(1,'Masculino'),
(2,'Feminino'),
(3,'Nao Informado');


CREATE TABLE status_ferias_enum (
    valor VARCHAR(20) PRIMARY KEY
);

INSERT INTO status_ferias_enum VALUES
('Agendado'),
('Cancelado'),
('Em_Andamento');


/* ============================================================
   CADASTROS BASE
   ============================================================ */

CREATE TABLE tb_endereco (
    pk_cep VARCHAR(20) PRIMARY KEY,
    numero INT,
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE tb_telefone (
    pk_id_telefone INT PRIMARY KEY AUTO_INCREMENT,
    ddd INT,
    numero VARCHAR(20)
);


/* ============================================================
   RESPONSAVEIS
   ============================================================ */

CREATE TABLE tb_responsavel (
    pk_cpf_responsavel CHAR(11) PRIMARY KEY,
    nome VARCHAR(100),
    sexo INT,
    email VARCHAR(150),
    telefone VARCHAR(30),
    grau_parentesco VARCHAR(50),
    fk_endereco VARCHAR(20),

    FOREIGN KEY (sexo) REFERENCES sexo_enum(id),
    FOREIGN KEY (fk_endereco) REFERENCES tb_endereco(pk_cep)
);

CREATE TABLE tb_responsavel2 (
    pk_cpf_responsavel CHAR(11) PRIMARY KEY,
    telefone VARCHAR(20),
    nome VARCHAR(30),
    sobrenome VARCHAR(50),
    sexo INT,
    email VARCHAR(255),
    grau_parentesco VARCHAR(50),
    FOREIGN KEY (sexo) REFERENCES sexo_enum(id)
);


/* ============================================================
   ALUNOS
   ============================================================ */

CREATE TABLE tb_aluno (
    pk_id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    data_nascimento DATE,
    raca VARCHAR(50),
    sexo INT,
    pcd_flag BOOLEAN,
    tipo_deficiencia VARCHAR(100),
    fk_endereco VARCHAR(20),
    fk_responsavel CHAR(11),
    fk_responsavel2 CHAR(11),
    
    FOREIGN KEY (sexo) REFERENCES sexo_enum(id),
    FOREIGN KEY (fk_endereco) REFERENCES tb_endereco(pk_cep),
    FOREIGN KEY (fk_responsavel) REFERENCES tb_responsavel(pk_cpf_responsavel),
    FOREIGN KEY (fk_responsavel2) REFERENCES tb_responsavel2(pk_cpf_responsavel)
);


/* ============================================================
   FUNCIONARIOS
   ============================================================ */

CREATE TABLE tb_funcionarios (
    pk_id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    cpf CHAR(11),
    nome VARCHAR(100),
    data_nascimento DATE,
    sexo INT,
    cargo VARCHAR(100),
    departamento VARCHAR(100),
    data_admissao DATE,
    fk_endereco VARCHAR(20),

    FOREIGN KEY (sexo) REFERENCES sexo_enum(id),
    FOREIGN KEY (fk_endereco) REFERENCES tb_endereco(pk_cep)
);


/* ============================================================
   TURMAS
   ============================================================ */

CREATE TABLE tb_turma (
    pk_id_turma INT PRIMARY KEY AUTO_INCREMENT,
    nome_turma VARCHAR(100),
    serie VARCHAR(20),
    turno VARCHAR(20),
    sala VARCHAR(20),
    ano_letivo INT,
    capacidade INT,
    id_professor INT,

    FOREIGN KEY (id_professor)
        REFERENCES tb_funcionarios(pk_id_funcionario)
);


/* ============================================================
   DISCIPLINAS
   ============================================================ */

CREATE TABLE tb_disciplina (
    pk_id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    nome_disciplina VARCHAR(150),
    area_conhecimento VARCHAR(100),
    carga_horaria INT
);


/* ============================================================
   MATRICULA
   ============================================================ */

CREATE TABLE tb_matricula (
    pk_id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT,
    fk_id_turma INT,
    data_matricula DATE,
    status VARCHAR(20),

    FOREIGN KEY (fk_id_aluno) REFERENCES tb_aluno(pk_id_aluno),
    FOREIGN KEY (fk_id_turma) REFERENCES tb_turma(pk_id_turma)
);


/* ============================================================
   FREQUENCIA ALUNO
   ============================================================ */

CREATE TABLE tb_frequencia_aluno (
    id_frequencia INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT,
    fk_id_turma INT,
    data_presenca DATE,
    presente_flag BOOLEAN,
    atraso_minutos INT,

    FOREIGN KEY (fk_id_aluno) REFERENCES tb_aluno(pk_id_aluno),
    FOREIGN KEY (fk_id_turma) REFERENCES tb_turma(pk_id_turma)
);


/* ============================================================
   FREQUENCIA FUNCIONARIO
   ============================================================ */

CREATE TABLE tb_frequencia_funcionario (
    id_frequencia INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_funcionario INT,
    data_presenca DATE,
    presente_flag BOOLEAN,
    horas_trabalhadas DECIMAL(5,2),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES tb_funcionarios(pk_id_funcionario)
);


/* ============================================================
   DESEMPENHO
   ============================================================ */

CREATE TABLE tb_desempenho (
    id_desempenho INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT,
    fk_id_turma INT,
    fk_id_disciplina INT,
    fk_id_funcionario INT,
    data_avaliacao DATE,
    nota DECIMAL(5,2),
    peso_avaliacao DECIMAL(5,2),

    FOREIGN KEY (fk_id_aluno) REFERENCES tb_aluno(pk_id_aluno),
    FOREIGN KEY (fk_id_turma) REFERENCES tb_turma(pk_id_turma),
    FOREIGN KEY (fk_id_disciplina) REFERENCES tb_disciplina(pk_id_disciplina),
    FOREIGN KEY (fk_id_funcionario) REFERENCES tb_funcionarios(pk_id_funcionario)
);


/* ============================================================
   SALARIOS
   ============================================================ */

CREATE TABLE tb_salarios (
    id_salario INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_funcionario INT,
    data_pagamento DATE,
    salario_base DECIMAL(12,2),
    hora_extra DECIMAL(12,2),
    desconto DECIMAL(12,2),
    beneficios DECIMAL(12,2),
    valor_liquido DECIMAL(12,2),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES tb_funcionarios(pk_id_funcionario)
);


/* ============================================================
   FERIAS
   ============================================================ */

CREATE TABLE tb_ferias (
    id_ferias INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_funcionario INT,
    data_inicio DATE,
    data_fim DATE,
    data_retorno DATE,
    abono_ferias DECIMAL(12,2),
    status VARCHAR(20),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES tb_funcionarios(pk_id_funcionario),

    FOREIGN KEY (status)
        REFERENCES status_ferias_enum(valor)
);


/* ============================================================
   ATESTADOS
   ============================================================ */

CREATE TABLE tb_atestados (
    id_atestado INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT NULL,
    fk_id_funcionario INT NULL,
    data_entrega DATE,
    data_inicio DATE,
    data_fim DATE,
    nome_medico VARCHAR(150),
    crm_medico VARCHAR(30),

    FOREIGN KEY (fk_id_aluno)
        REFERENCES tb_aluno(pk_id_aluno),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES tb_funcionarios(pk_id_funcionario)
);



/* ============================================================
   DATA WAREHOUSE
   ============================================================ */

CREATE DATABASE creche_dw;
USE creche_dw;


/* ============================================================
   DIMENSOES
   ============================================================ */

CREATE TABLE dim_tempo (
    sk_id_tempo INT PRIMARY KEY AUTO_INCREMENT,
    data_completa DATE UNIQUE,
    dia INT,
    mes INT,
    trimestre INT,
    semestre INT,
    ano INT
);

CREATE TABLE dim_aluno (
    sk_id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno_nk INT,
    nome VARCHAR(150),
    sexo CHAR(1),
    cidade VARCHAR(100),
    pcd_flag BOOLEAN
);

CREATE TABLE dim_responsavel (
    sk_id_responsavel INT PRIMARY KEY AUTO_INCREMENT,
    cpf_responsavel_nk CHAR(11),
    nome_completo VARCHAR(150),
    cidade VARCHAR(100)
);

CREATE TABLE dim_funcionario (
    sk_id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario_nk INT,
    nome_completo VARCHAR(150),
    cargo VARCHAR(100),
    cidade VARCHAR(100)
);

CREATE TABLE dim_turma (
    sk_id_turma INT PRIMARY KEY AUTO_INCREMENT,
    codigo_turma INT,
    serie VARCHAR(20),
    turno VARCHAR(20),
    sala VARCHAR(20)
);

CREATE TABLE dim_disciplina (
    sk_id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    codigo_disciplina INT,
    nome_disciplina VARCHAR(150)
);

CREATE TABLE dim_local (
    sk_id_local INT PRIMARY KEY AUTO_INCREMENT,
    unidade VARCHAR(100),
    sala VARCHAR(50),
    cidade VARCHAR(100)
);


/* ============================================================
   TABELAS FATO COM FOREIGN KEYS
   (substitua as tabelas fato atuais por estas versões)
   ============================================================ */


/* ============================================================
   FATO MATRICULA
   ============================================================ */

CREATE TABLE fato_matricula (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT,
    fk_id_turma INT,
    fk_id_tempo INT,
    fk_id_responsavel INT,
    status_matricula VARCHAR(20),

    FOREIGN KEY (fk_id_aluno)
        REFERENCES dim_aluno(sk_id_aluno),

    FOREIGN KEY (fk_id_turma)
        REFERENCES dim_turma(sk_id_turma),

    FOREIGN KEY (fk_id_tempo)
        REFERENCES dim_tempo(sk_id_tempo),

    FOREIGN KEY (fk_id_responsavel)
        REFERENCES dim_responsavel(sk_id_responsavel)
);



/* ============================================================
   FATO DESEMPENHO
   ============================================================ */

CREATE TABLE fato_desempenho (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT,
    fk_id_turma INT,
    fk_id_disciplina INT,
    fk_id_funcionario INT,
    fk_id_tempo INT,
    nota DECIMAL(5,2),
    peso_avaliacao DECIMAL(5,2),

    FOREIGN KEY (fk_id_aluno)
        REFERENCES dim_aluno(sk_id_aluno),

    FOREIGN KEY (fk_id_turma)
        REFERENCES dim_turma(sk_id_turma),

    FOREIGN KEY (fk_id_disciplina)
        REFERENCES dim_disciplina(sk_id_disciplina),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES dim_funcionario(sk_id_funcionario),

    FOREIGN KEY (fk_id_tempo)
        REFERENCES dim_tempo(sk_id_tempo)
);



/* ============================================================
   FATO FREQUENCIA ALUNO
   ============================================================ */

CREATE TABLE fato_frequencia_aluno (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT,
    fk_id_turma INT,
    fk_id_tempo INT,
    presente_flag INT,
    atraso_minutos INT,

    FOREIGN KEY (fk_id_aluno)
        REFERENCES dim_aluno(sk_id_aluno),

    FOREIGN KEY (fk_id_turma)
        REFERENCES dim_turma(sk_id_turma),

    FOREIGN KEY (fk_id_tempo)
        REFERENCES dim_tempo(sk_id_tempo)
);



/* ============================================================
   FATO FREQUENCIA FUNCIONARIO
   ============================================================ */

CREATE TABLE fato_frequencia_funcionario (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_funcionario INT,
    fk_id_tempo INT,
    fk_id_local INT,
    presente_flag INT,
    horas_trabalhadas DECIMAL(5,2),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES dim_funcionario(sk_id_funcionario),

    FOREIGN KEY (fk_id_tempo)
        REFERENCES dim_tempo(sk_id_tempo),

    FOREIGN KEY (fk_id_local)
        REFERENCES dim_local(sk_id_local)
);



/* ============================================================
   FATO FINANCEIRO RH
   ============================================================ */

CREATE TABLE fato_financeiro_rh (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_funcionario INT,
    fk_id_tempo INT,
    salario_base DECIMAL(12,2),
    hora_extra DECIMAL(12,2),
    desconto DECIMAL(12,2),
    beneficios DECIMAL(12,2),
    valor_liquido DECIMAL(12,2),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES dim_funcionario(sk_id_funcionario),

    FOREIGN KEY (fk_id_tempo)
        REFERENCES dim_tempo(sk_id_tempo)
);



/* ============================================================
   FATO FERIAS
   ============================================================ */

CREATE TABLE fato_ferias (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_funcionario INT,
    fk_id_tempo_inicio INT,
    fk_id_tempo_fim INT,
    fk_id_tempo_retorno INT,
    dias_ferias INT,
    abono_ferias DECIMAL(12,2),
    status_ferias VARCHAR(30),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES dim_funcionario(sk_id_funcionario),

    FOREIGN KEY (fk_id_tempo_inicio)
        REFERENCES dim_tempo(sk_id_tempo),

    FOREIGN KEY (fk_id_tempo_fim)
        REFERENCES dim_tempo(sk_id_tempo),

    FOREIGN KEY (fk_id_tempo_retorno)
        REFERENCES dim_tempo(sk_id_tempo)
);



/* ============================================================
   FATO ATESTADOS
   ============================================================ */

CREATE TABLE fato_atestados (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT NULL,
    fk_id_funcionario INT NULL,
    fk_id_tempo_entrega INT,
    fk_id_tempo_inicio INT,
    fk_id_tempo_fim INT,
    dias_afastamento INT,

    FOREIGN KEY (fk_id_aluno)
        REFERENCES dim_aluno(sk_id_aluno),

    FOREIGN KEY (fk_id_funcionario)
        REFERENCES dim_funcionario(sk_id_funcionario),

    FOREIGN KEY (fk_id_tempo_entrega)
        REFERENCES dim_tempo(sk_id_tempo),

    FOREIGN KEY (fk_id_tempo_inicio)
        REFERENCES dim_tempo(sk_id_tempo),

    FOREIGN KEY (fk_id_tempo_fim)
        REFERENCES dim_tempo(sk_id_tempo)
);


INSERT INTO dim_tempo (
    data_completa,dia,mes,trimestre,semestre,ano
)
WITH RECURSIVE calendario AS (
    SELECT DATE('2024-01-01') dt
    UNION ALL
    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM calendario
    WHERE dt < '2030-12-31'
)
SELECT
    dt,
    DAY(dt),
    MONTH(dt),
    QUARTER(dt),
    CASE WHEN MONTH(dt)<=6 THEN 1 ELSE 2 END,
    YEAR(dt)
FROM calendario;

/* ============================================================
   ETL - DIM ALUNO
   ============================================================ */

INSERT INTO dim_aluno (
    id_aluno_nk,
    nome,
    sexo,
    cidade,
    pcd_flag
)
SELECT
    a.pk_id_aluno,
    a.nome,
    CASE
        WHEN a.sexo = 1 THEN 'M'
        WHEN a.sexo = 2 THEN 'F'
        ELSE 'N'
    END,
    e.cidade,
    a.pcd_flag
FROM creche_db.tb_aluno a
JOIN creche_db.tb_endereco e
    ON a.fk_endereco = e.pk_cep;


/* ============================================================
   ETL - DIM RESPONSAVEL
   ============================================================ */

INSERT INTO dim_responsavel (
    cpf_responsavel_nk,
    nome_completo,
    cidade
)
SELECT
    r.pk_cpf_responsavel,
    CONCAT(r.nome,' - ',r.grau_parentesco),
    e.cidade
FROM creche_db.tb_responsavel r
JOIN creche_db.tb_endereco e
    ON r.fk_endereco = e.pk_cep;


/* ============================================================
   ETL - DIM FUNCIONARIO
   ============================================================ */

INSERT INTO dim_funcionario (
    id_funcionario_nk,
    nome_completo,
    cargo,
    cidade
)
SELECT
    f.pk_id_funcionario,
    f.nome,
    f.cargo,
    e.cidade
FROM creche_db.tb_funcionarios f
JOIN creche_db.tb_endereco e
    ON f.fk_endereco = e.pk_cep;


/* ============================================================
   ETL - DIM TURMA
   ============================================================ */

INSERT INTO dim_turma (
    codigo_turma,
    serie,
    turno,
    sala
)
SELECT
    pk_id_turma,
    serie,
    turno,
    sala
FROM creche_db.tb_turma;


/* ============================================================
   ETL - DIM DISCIPLINA
   ============================================================ */

INSERT INTO dim_disciplina (
    codigo_disciplina,
    nome_disciplina
)
SELECT
    pk_id_disciplina,
    nome_disciplina
FROM creche_db.tb_disciplina;


/* ============================================================
   ETL - DIM LOCAL
   ============================================================ */

INSERT INTO dim_local (
    unidade,
    sala,
    cidade
)
SELECT DISTINCT
    'Creche Central',
    sala,
    'Sao Paulo'
FROM creche_db.tb_turma;


/* ============================================================
   ETL - FATO MATRICULA
   ============================================================ */

INSERT INTO fato_matricula (
    fk_id_aluno,
    fk_id_turma,
    fk_id_tempo,
    fk_id_responsavel,
    status_matricula
)
SELECT
    da.sk_id_aluno,
    dtu.sk_id_turma,
    dt.sk_id_tempo,
    dr.sk_id_responsavel,
    m.status
FROM creche_db.tb_matricula m
JOIN dim_aluno da
    ON da.id_aluno_nk = m.fk_id_aluno
JOIN dim_turma dtu
    ON dtu.codigo_turma = m.fk_id_turma
JOIN dim_tempo dt
    ON dt.data_completa = m.data_matricula
JOIN creche_db.tb_aluno a
    ON a.pk_id_aluno = m.fk_id_aluno
JOIN dim_responsavel dr
    ON dr.cpf_responsavel_nk = a.fk_responsavel;


/* ============================================================
   ETL - FATO DESEMPENHO
   ============================================================ */

INSERT INTO fato_desempenho (
    fk_id_aluno,
    fk_id_turma,
    fk_id_disciplina,
    fk_id_funcionario,
    fk_id_tempo,
    nota,
    peso_avaliacao
)
SELECT
    da.sk_id_aluno,
    dtu.sk_id_turma,
    dd.sk_id_disciplina,
    df.sk_id_funcionario,
    dt.sk_id_tempo,
    d.nota,
    d.peso_avaliacao
FROM creche_db.tb_desempenho d
JOIN dim_aluno da
    ON da.id_aluno_nk = d.fk_id_aluno
JOIN dim_turma dtu
    ON dtu.codigo_turma = d.fk_id_turma
JOIN dim_disciplina dd
    ON dd.codigo_disciplina = d.fk_id_disciplina
JOIN dim_funcionario df
    ON df.id_funcionario_nk = d.fk_id_funcionario
JOIN dim_tempo dt
    ON dt.data_completa = d.data_avaliacao;


/* ============================================================
   ETL - FATO FREQUENCIA ALUNO
   ============================================================ */

INSERT INTO fato_frequencia_aluno (
    fk_id_aluno,
    fk_id_turma,
    fk_id_tempo,
    presente_flag,
    atraso_minutos
)
SELECT
    da.sk_id_aluno,
    dtu.sk_id_turma,
    dt.sk_id_tempo,
    fa.presente_flag,
    fa.atraso_minutos
FROM creche_db.tb_frequencia_aluno fa
JOIN dim_aluno da
    ON da.id_aluno_nk = fa.fk_id_aluno
JOIN dim_turma dtu
    ON dtu.codigo_turma = fa.fk_id_turma
JOIN dim_tempo dt
    ON dt.data_completa = fa.data_presenca;


/* ============================================================
   ETL - FATO FREQUENCIA FUNCIONARIO
   ============================================================ */

INSERT INTO fato_frequencia_funcionario (
    fk_id_funcionario,
    fk_id_tempo,
    fk_id_local,
    presente_flag,
    horas_trabalhadas
)
SELECT
    df.sk_id_funcionario,
    dt.sk_id_tempo,
    dl.sk_id_local,
    ff.presente_flag,
    ff.horas_trabalhadas
FROM creche_db.tb_frequencia_funcionario ff
JOIN dim_funcionario df
    ON df.id_funcionario_nk = ff.fk_id_funcionario
JOIN dim_tempo dt
    ON dt.data_completa = ff.data_presenca
JOIN dim_local dl
    ON dl.unidade = 'Creche Central'
LIMIT 999999;


/* ============================================================
   ETL - FATO FINANCEIRO RH
   ============================================================ */

INSERT INTO fato_financeiro_rh (
    fk_id_funcionario,
    fk_id_tempo,
    salario_base,
    hora_extra,
    desconto,
    beneficios,
    valor_liquido
)
SELECT
    df.sk_id_funcionario,
    dt.sk_id_tempo,
    s.salario_base,
    s.hora_extra,
    s.desconto,
    s.beneficios,
    s.valor_liquido
FROM creche_db.tb_salarios s
JOIN dim_funcionario df
    ON df.id_funcionario_nk = s.fk_id_funcionario
JOIN dim_tempo dt
    ON dt.data_completa = s.data_pagamento;


/* ============================================================
   ETL - FATO FERIAS
   ============================================================ */

INSERT INTO fato_ferias (
    fk_id_funcionario,
    fk_id_tempo_inicio,
    fk_id_tempo_fim,
    fk_id_tempo_retorno,
    dias_ferias,
    abono_ferias,
    status_ferias
)
SELECT
    df.sk_id_funcionario,
    dt1.sk_id_tempo,
    dt2.sk_id_tempo,
    dt3.sk_id_tempo,
    DATEDIFF(f.data_fim,f.data_inicio),
    f.abono_ferias,
    f.status
FROM creche_db.tb_ferias f
JOIN dim_funcionario df
    ON df.id_funcionario_nk = f.fk_id_funcionario
JOIN dim_tempo dt1
    ON dt1.data_completa = f.data_inicio
JOIN dim_tempo dt2
    ON dt2.data_completa = f.data_fim
JOIN dim_tempo dt3
    ON dt3.data_completa = f.data_retorno;


/* ============================================================
   ETL - FATO ATESTADOS
   ============================================================ */

INSERT INTO fato_atestados (
    fk_id_aluno,
    fk_id_funcionario,
    fk_id_tempo_entrega,
    fk_id_tempo_inicio,
    fk_id_tempo_fim,
    dias_afastamento
)
SELECT
    da.sk_id_aluno,
    df.sk_id_funcionario,
    dt1.sk_id_tempo,
    dt2.sk_id_tempo,
    dt3.sk_id_tempo,
    DATEDIFF(a.data_fim,a.data_inicio)
FROM creche_db.tb_atestados a
LEFT JOIN dim_aluno da
    ON da.id_aluno_nk = a.fk_id_aluno
LEFT JOIN dim_funcionario df
    ON df.id_funcionario_nk = a.fk_id_funcionario
JOIN dim_tempo dt1
    ON dt1.data_completa = a.data_entrega
JOIN dim_tempo dt2
    ON dt2.data_completa = a.data_inicio
JOIN dim_tempo dt3
    ON dt3.data_completa = a.data_fim;