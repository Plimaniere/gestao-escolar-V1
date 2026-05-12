DROP DATABASE IF EXISTS creche_dw;

DROP DATABASE IF EXISTS creche_db;

CREATE DATABASE creche_db;

USE creche_db;

-- ============================================
-- MODULO: ESTRUTURA GERAL / ENUMS
-- ============================================

CREATE TABLE tb_sexo_enum (
 id INT PRIMARY KEY,
 descricao VARCHAR(20)
);

INSERT INTO tb_sexo_enum VALUES
(1,'Masculino'),
(2,'Feminino'),
(3,'Nao Informado');

CREATE TABLE tb_status_ferias_enum (
 valor VARCHAR(20) PRIMARY KEY
);

INSERT INTO tb_status_ferias_enum VALUES
('Agendado'),
('Cancelado'),
('Em_Andamento');

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_endereco (
 pk_cep VARCHAR(20),
 numero INT,
 complemento varchar(50),
 bairro VARCHAR(100),
 cidade VARCHAR(100),
 estado CHAR(2),
 PRIMARY KEY (pk_cep, numero)
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_telefone (
 pk_id_telefone INT PRIMARY KEY AUTO_INCREMENT,
 pais varchar(20) not null,
 ddd INT,
 numero VARCHAR(20),
 tipo varchar(30)
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_responsavel (
 pk_cpf_responsavel CHAR(11) PRIMARY KEY,
 nome VARCHAR(50),
 sobrenome VARCHAR(100),
 sexo INT,
 email VARCHAR(150),
 telefone VARCHAR(30),
 grau_parentesco VARCHAR(50),
 fk_endereco VARCHAR(150),
 fk_numero_endereco INT,
 FOREIGN KEY (sexo) REFERENCES tb_sexo_enum(id),
 FOREIGN KEY (fk_endereco, fk_numero_endereco)
 REFERENCES tb_endereco(pk_cep, numero)
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_responsavel2 (
 pk_cpf_responsavel CHAR(11) PRIMARY KEY,
 telefone VARCHAR(20),
 nome VARCHAR(50),
 sobrenome VARCHAR(100),
 sexo INT,
 email VARCHAR(255),
 grau_parentesco VARCHAR(50),
 FOREIGN KEY (sexo) REFERENCES tb_sexo_enum(id)
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_aluno (
 pk_id_aluno INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(50),
 sobrenome VARCHAR(100),
 data_nascimento DATE,
 raca VARCHAR(50),
 sexo INT,
 pcd_flag BOOLEAN DEFAULT FALSE,
 tipo_deficiencia VARCHAR(100),
 fk_endereco VARCHAR(20),
 fk_numero_endereco INT,
 fk_responsavel CHAR(11),
 fk_responsavel2 CHAR(11),

 FOREIGN KEY (sexo) REFERENCES tb_sexo_enum(id),
 FOREIGN KEY (fk_endereco, fk_numero_endereco)
 REFERENCES tb_endereco(pk_cep, numero),
 FOREIGN KEY (fk_responsavel)
 REFERENCES tb_responsavel(pk_cpf_responsavel)
 ON DELETE RESTRICT,
 FOREIGN KEY (fk_responsavel2)
 REFERENCES tb_responsavel2(pk_cpf_responsavel)
 ON DELETE RESTRICT
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_doencas (
 doencas_cid VARCHAR(50) PRIMARY KEY,
 nome_doenca VARCHAR(255) NOT NULL,
 tipo_doenca VARCHAR(100) NOT NULL,
 especialidade_doenca VARCHAR(50) NOT NULL,
 vacinas VARCHAR(255) NOT NULL
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_alunos_pcd (
 fk_id_aluno INT PRIMARY KEY,
 cid_deficiencia VARCHAR(50) NOT NULL,
 esp_deficiencia VARCHAR(100) NOT NULL,
 idade VARCHAR(20) NOT NULL,
 id_endereco VARCHAR(20) NOT NULL,
 
 FOREIGN KEY (fk_id_aluno) 
 REFERENCES tb_aluno(pk_id_aluno) 
 ON DELETE RESTRICT,
 FOREIGN KEY (cid_deficiencia) 
 REFERENCES tb_doencas(doencas_cid) 
 ON DELETE RESTRICT
);

-- ============================================
-- MODULO: RH
-- ============================================

CREATE TABLE tb_funcionarios (
 pk_id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
 cpf CHAR(11) UNIQUE,
 nome VARCHAR(50),
 sobrenome VARCHAR(100),
 data_nascimento DATE,
 sexo INT,
 cargo VARCHAR(100),
 departamento VARCHAR(100),
 data_admissao DATE,
 fk_numero_endereco INT,
 fk_endereco VARCHAR(20),
 FOREIGN KEY (sexo) REFERENCES tb_sexo_enum(id),
 FOREIGN KEY (fk_endereco, fk_numero_endereco)
 REFERENCES tb_endereco(pk_cep, numero)
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_turma (
 pk_id_turma INT PRIMARY KEY AUTO_INCREMENT,
 nome_turma VARCHAR(100),
 serie VARCHAR(20),
 turno VARCHAR(20),
 sala VARCHAR(20),
 ano_letivo INT,
 capacidade INT CHECK (capacidade > 0),
 id_professor INT,
 FOREIGN KEY (id_professor)
 REFERENCES tb_funcionarios(pk_id_funcionario)
 ON DELETE RESTRICT
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_disciplina (
 pk_id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
 nome_disciplina VARCHAR(150),
 area_conhecimento VARCHAR(100),
 carga_horaria INT
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_matricula (
 PRIMARY KEY (fk_id_aluno, fk_id_turma, data_matricula),
 fk_id_aluno INT,
 fk_id_turma INT,
 data_matricula DATE,
 status ENUM(
'Ativa',
'Cancelada',
'Concluida'
) DEFAULT 'Ativa',

 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_aluno(pk_id_aluno)
 ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_turma)
 REFERENCES tb_turma(pk_id_turma)
 ON DELETE RESTRICT
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_frequencia_aluno (
 PRIMARY KEY ( fk_id_aluno, fk_id_turma, data_presenca
),
 fk_id_aluno INT,
 fk_id_turma INT,
 data_presenca DATE,
 presente_flag BOOLEAN NOT NULL CHECK (presente_flag IN (0,1)),
 atraso_minutos INT DEFAULT 0,
 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_aluno(pk_id_aluno)
 ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_turma)
 REFERENCES tb_turma(pk_id_turma)
 ON DELETE RESTRICT
);

-- ============================================
-- MODULO: RH
-- ============================================

CREATE TABLE tb_frequencia_funcionario (
 PRIMARY KEY (fk_id_funcionario, data_presenca),
 fk_id_funcionario INT,
 data_presenca DATE,
 presente_flag BOOLEAN NOT NULL CHECK (presente_flag IN (0,1)),
 horas_trabalhadas DECIMAL(5,2) DEFAULT 0,
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario) ON DELETE RESTRICT
);

-- ============================================
-- MODULO: ACADEMICO
-- ============================================

CREATE TABLE tb_desempenho (
PRIMARY KEY (fk_id_aluno, fk_id_disciplina, data_avaliacao
),
 fk_id_aluno INT,
 fk_id_turma INT,
 fk_id_disciplina INT,
 fk_id_funcionario INT,
 data_avaliacao DATE,
 nota DECIMAL(5,2)
 CHECK (nota >= 0 AND nota <= 10),
 peso_avaliacao DECIMAL(5,2),
 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_aluno(pk_id_aluno)
 ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_turma)
 REFERENCES tb_turma(pk_id_turma)
 ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_disciplina)
 REFERENCES tb_disciplina(pk_id_disciplina)
 ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario)
 ON DELETE RESTRICT
);

-- ============================================
-- MODULO: FINANCEIRO
-- ============================================

CREATE TABLE tb_salarios (
 id_salario INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_funcionario INT,
 data_pagamento DATE,
 salario_base DECIMAL(12,2),
 hora_extra DECIMAL(12,2),
 desconto DECIMAL(12,2),
 beneficios DECIMAL(12,2),
 CHECK (salario_base >= 0),
CHECK (hora_extra >= 0),
CHECK (desconto >= 0),
CHECK (beneficios >= 0),
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario) ON DELETE RESTRICT
);

-- ============================================
-- MODULO: RH
-- ============================================

CREATE TABLE tb_ferias (
 id_ferias INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_funcionario INT,
 data_inicio DATE,
 data_fim DATE,
 data_retorno DATE,
 abono_ferias DECIMAL(12,2),
 status VARCHAR(20),
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario) ON DELETE RESTRICT,
 FOREIGN KEY (status)
 REFERENCES tb_status_ferias_enum(valor)
);

-- ============================================
-- MODULO: RH
-- ============================================

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
 REFERENCES tb_aluno(pk_id_aluno) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario) ON DELETE RESTRICT,
 CHECK (
 (fk_id_aluno IS NOT NULL AND fk_id_funcionario IS NULL)
 OR
 (fk_id_aluno IS NULL AND fk_id_funcionario IS NOT NULL)
)
);

-- ============================================
-- MODULO: DATA WAREHOUSE (OLAP)
-- ============================================

CREATE DATABASE IF NOT EXISTS creche_dw;

USE creche_dw;

CREATE TABLE tb_dim_tempo (
 sk_id_tempo INT PRIMARY KEY AUTO_INCREMENT,
 data_completa DATE UNIQUE,
 dia INT,
 mes INT,
 trimestre INT,
 semestre INT,
 ano INT
);

CREATE TABLE tb_dim_aluno (
 sk_id_aluno INT PRIMARY KEY AUTO_INCREMENT,
 id_aluno_nk INT,
 nome VARCHAR(150),
 sexo CHAR(1),
 cidade VARCHAR(100),
 pcd_flag BOOLEAN
);

CREATE TABLE tb_dim_doenca (
 sk_id_doenca INT PRIMARY KEY AUTO_INCREMENT,
 doenca_cid_nk VARCHAR(50),
 nome_doenca VARCHAR(255),
 tipo_doenca VARCHAR(100),
 especialidade VARCHAR(50)
);

CREATE TABLE tb_dim_perfil_pcd (
 sk_id_pcd INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_aluno_nk INT, 
 cid_referencia VARCHAR(50),
 especialidade_deficiencia VARCHAR(100),
 idade_registro VARCHAR(20)
);

CREATE TABLE tb_dim_responsavel (
 sk_id_responsavel INT PRIMARY KEY AUTO_INCREMENT,
 cpf_responsavel_nk CHAR(11),
 nome VARCHAR(100),
 grau_parentesco VARCHAR(50),
 cidade VARCHAR(100)
);

CREATE TABLE tb_dim_funcionario (
 sk_id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
 id_funcionario_nk INT,
 nome_completo VARCHAR(150),
 cargo VARCHAR(100),
 cidade VARCHAR(100)
);

CREATE TABLE tb_dim_turma (
 sk_id_turma INT PRIMARY KEY AUTO_INCREMENT,
 codigo_turma INT,
 serie VARCHAR(20),
 turno VARCHAR(20),
 sala VARCHAR(20)
);

CREATE TABLE tb_dim_disciplina (
 sk_id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
 codigo_disciplina INT,
 nome_disciplina VARCHAR(150)
);

CREATE TABLE tb_dim_local (
 sk_id_local INT PRIMARY KEY AUTO_INCREMENT,
 unidade VARCHAR(100),
 sala VARCHAR(50),
 cidade VARCHAR(100)
);

CREATE TABLE tb_fato_matricula (
 id_fato INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_aluno INT,
 fk_id_turma INT,
 fk_id_tempo INT,
 fk_id_responsavel INT,
 status_matricula VARCHAR(20),
 UNIQUE (
 fk_id_aluno,
 fk_id_turma,
 fk_id_tempo
),
 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_dim_aluno(sk_id_aluno) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_turma)
 REFERENCES tb_dim_turma(sk_id_turma) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_responsavel)
 REFERENCES tb_dim_responsavel(sk_id_responsavel) ON DELETE RESTRICT
);

CREATE TABLE tb_fato_desempenho (
 id_fato INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_aluno INT,
 fk_id_turma INT,
 fk_id_disciplina INT,
 fk_id_funcionario INT,
 fk_id_tempo INT,
 UNIQUE (fk_id_aluno, fk_id_disciplina, fk_id_tempo),
 nota DECIMAL(5,2) CHECK (nota >= 0 AND nota <= 10),
 peso_avaliacao DECIMAL(5,2) CHECK (peso_avaliacao > 0),
 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_dim_aluno(sk_id_aluno) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_turma)
 REFERENCES tb_dim_turma(sk_id_turma) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_disciplina)
 REFERENCES tb_dim_disciplina(sk_id_disciplina) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_dim_funcionario(sk_id_funcionario) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT
);

CREATE TABLE tb_fato_frequencia_aluno (
 id_fato INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_aluno INT,
 fk_id_turma INT,
 fk_id_tempo INT,
 UNIQUE (
 fk_id_aluno,
 fk_id_turma,
 fk_id_tempo
),
 presente_flag INT,
 CHECK (presente_flag IN (0,1)),
 atraso_minutos INT,
 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_dim_aluno(sk_id_aluno) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_turma)
 REFERENCES tb_dim_turma(sk_id_turma) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT
);

CREATE TABLE tb_fato_frequencia_funcionario (
 id_fato INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_funcionario INT,
 fk_id_tempo INT,
 fk_id_local INT,
 UNIQUE (
 fk_id_funcionario,
 fk_id_tempo,
 fk_id_local
),
 presente_flag INT,
 CHECK (presente_flag IN (0,1)),
 horas_trabalhadas DECIMAL(5,2),
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_dim_funcionario(sk_id_funcionario) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_local)
 REFERENCES tb_dim_local(sk_id_local) ON DELETE RESTRICT
);

CREATE TABLE tb_fato_financeiro_rh (
 PRIMARY KEY (
 fk_id_funcionario,
 fk_id_tempo
),
 fk_id_funcionario INT,
 fk_id_tempo INT,
 salario_base DECIMAL(12,2),
 CHECK (salario_base >= 0),
 hora_extra DECIMAL(12,2),
 CHECK (hora_extra >= 0),
 desconto DECIMAL(12,2),
 CHECK (desconto >= 0),
 beneficios DECIMAL(12,2),
 CHECK (beneficios >= 0),
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_dim_funcionario(sk_id_funcionario) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT
);

CREATE TABLE tb_fato_ferias (
 PRIMARY KEY (
 fk_id_funcionario,
 fk_id_tempo_inicio
),
 fk_id_funcionario INT,
 fk_id_tempo_inicio INT,
 fk_id_tempo_fim INT,
 fk_id_tempo_retorno INT,
 dias_ferias INT,
 CHECK (dias_ferias >= 0),
 abono_ferias DECIMAL(12,2),
 CHECK (abono_ferias >= 0),
 status_ferias VARCHAR(30),
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_dim_funcionario(sk_id_funcionario) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo_inicio)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo_fim)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo_retorno)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT
);

CREATE TABLE tb_fato_atestados (
 id_fato INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_aluno INT NULL,
 fk_id_funcionario INT NULL,
 fk_id_tempo_entrega INT,
 fk_id_tempo_inicio INT,
 fk_id_tempo_fim INT,
 dias_afastamento INT,
 UNIQUE (fk_id_aluno, fk_id_funcionario, fk_id_tempo_inicio),
 FOREIGN KEY (fk_id_aluno)
 REFERENCES tb_dim_aluno(sk_id_aluno) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_dim_funcionario(sk_id_funcionario) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo_entrega)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo_inicio)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 FOREIGN KEY (fk_id_tempo_fim)
 REFERENCES tb_dim_tempo(sk_id_tempo) ON DELETE RESTRICT,
 CHECK (
 (fk_id_aluno IS NOT NULL AND fk_id_funcionario IS NULL)
 OR
 (fk_id_aluno IS NULL AND fk_id_funcionario IS NOT NULL)
),
CHECK (dias_afastamento >= 0)
);

-- ============================================
-- INSERTS
-- ============================================

INSERT IGNORE INTO tb_dim_tempo (
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

INSERT IGNORE INTO tb_dim_aluno (
 id_aluno_nk,
 nome,
 sexo,
 cidade,
 pcd_flag
)
SELECT
 a.pk_id_aluno,
 CONCAT(a.nome, ' ', a.sobrenome),
 CASE
 WHEN a.sexo = 1 THEN 'M'
 WHEN a.sexo = 2 THEN 'F'
 ELSE 'N'
 END,
 e.cidade,
 a.pcd_flag
FROM creche_db.tb_aluno a
JOIN creche_db.tb_endereco e
 ON a.fk_endereco = e.pk_cep
AND a.fk_numero_endereco = e.numero;
 
INSERT IGNORE INTO tb_dim_doenca (
 doenca_cid_nk,
 nome_doenca,
 tipo_doenca,
 especialidade
)
SELECT 
 doencas_cid,
 nome_doenca,
 tipo_doenca,
 especialidade_doenca
FROM creche_db.tb_doencas;

INSERT IGNORE INTO tb_dim_perfil_pcd (
 fk_id_aluno_nk,
 cid_referencia,
 especialidade_deficiencia,
 idade_registro
)
SELECT 
 p.fk_id_aluno,
 p.cid_deficiencia,
 p.esp_deficiencia,
 p.idade
FROM creche_db.tb_alunos_pcd p
JOIN creche_db.tb_aluno a ON p.fk_id_aluno = a.pk_id_aluno;
 
INSERT IGNORE INTO tb_dim_responsavel (
 cpf_responsavel_nk,
 nome,
 grau_parentesco,
 cidade
)
SELECT
 r.pk_cpf_responsavel,
 r.nome,
 r.grau_parentesco,
 e.cidade
FROM creche_db.tb_responsavel r
JOIN creche_db.tb_endereco e
 ON r.fk_endereco = e.pk_cep
AND r.fk_numero_endereco = e.numero;
 
INSERT IGNORE INTO tb_dim_funcionario (
 id_funcionario_nk,
 nome_completo,
 cargo,
 cidade
)
SELECT
 f.pk_id_funcionario,
 CONCAT(f.nome, ' ', f.sobrenome),
 f.cargo,
 e.cidade
FROM creche_db.tb_funcionarios f
JOIN creche_db.tb_endereco e
 ON f.fk_endereco = e.pk_cep
AND f.fk_numero_endereco = e.numero;
 
INSERT IGNORE INTO tb_dim_turma (
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

INSERT IGNORE INTO tb_dim_disciplina (
 codigo_disciplina,
 nome_disciplina
)
SELECT
 pk_id_disciplina,
 nome_disciplina
FROM creche_db.tb_disciplina;

INSERT IGNORE INTO tb_dim_local (
 unidade,
 sala,
 cidade
)
SELECT DISTINCT
 'Creche Central',
 sala,
 'Sao Paulo'
FROM creche_db.tb_turma;

INSERT IGNORE INTO tb_fato_matricula (
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
JOIN tb_dim_aluno da
 ON da.id_aluno_nk = m.fk_id_aluno
JOIN tb_dim_turma dtu
 ON dtu.codigo_turma = m.fk_id_turma
JOIN tb_dim_tempo dt
 ON dt.data_completa = m.data_matricula
JOIN creche_db.tb_aluno a
 ON a.pk_id_aluno = m.fk_id_aluno
JOIN tb_dim_responsavel dr
 ON dr.cpf_responsavel_nk = a.fk_responsavel;
 
INSERT IGNORE INTO tb_fato_desempenho (
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
JOIN tb_dim_aluno da
 ON da.id_aluno_nk = d.fk_id_aluno
JOIN tb_dim_turma dtu
 ON dtu.codigo_turma = d.fk_id_turma
JOIN tb_dim_disciplina dd
 ON dd.codigo_disciplina = d.fk_id_disciplina
JOIN tb_dim_funcionario df
 ON df.id_funcionario_nk = d.fk_id_funcionario
JOIN tb_dim_tempo dt
 ON dt.data_completa = d.data_avaliacao;
 
INSERT IGNORE INTO tb_fato_frequencia_aluno (
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
JOIN tb_dim_aluno da
 ON da.id_aluno_nk = fa.fk_id_aluno
JOIN tb_dim_turma dtu
 ON dtu.codigo_turma = fa.fk_id_turma
JOIN tb_dim_tempo dt
 ON dt.data_completa = fa.data_presenca;
 
INSERT IGNORE INTO tb_fato_frequencia_funcionario (
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
JOIN tb_dim_funcionario df
 ON df.id_funcionario_nk = ff.fk_id_funcionario
JOIN tb_dim_tempo dt
 ON dt.data_completa = ff.data_presenca
JOIN tb_dim_local dl
 ON dl.unidade = 'Creche Central'
LIMIT 999999;

INSERT IGNORE INTO tb_fato_financeiro_rh (
 fk_id_funcionario,
 fk_id_tempo,
 salario_base,
 hora_extra,
 desconto,
 beneficios
)
SELECT
 df.sk_id_funcionario,
 dt.sk_id_tempo,
 s.salario_base,
 s.hora_extra,
 s.desconto,
 s.beneficios
FROM creche_db.tb_salarios s
JOIN tb_dim_funcionario df
 ON df.id_funcionario_nk = s.fk_id_funcionario
JOIN tb_dim_tempo dt
 ON dt.data_completa = s.data_pagamento;
 
INSERT IGNORE INTO tb_fato_ferias (
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
JOIN tb_dim_funcionario df
 ON df.id_funcionario_nk = f.fk_id_funcionario
JOIN tb_dim_tempo dt1
 ON dt1.data_completa = f.data_inicio
JOIN tb_dim_tempo dt2
 ON dt2.data_completa = f.data_fim
JOIN tb_dim_tempo dt3
 ON dt3.data_completa = f.data_retorno;
 
INSERT IGNORE INTO tb_fato_atestados (
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
LEFT JOIN tb_dim_aluno da
 ON da.id_aluno_nk = a.fk_id_aluno
LEFT JOIN tb_dim_funcionario df
 ON df.id_funcionario_nk = a.fk_id_funcionario
JOIN tb_dim_tempo dt1
 ON dt1.data_completa = a.data_entrega
JOIN tb_dim_tempo dt2
 ON dt2.data_completa = a.data_inicio
JOIN tb_dim_tempo dt3
 ON dt3.data_completa = a.data_fim;

-- ============================================
-- ALTER TABLES
-- ============================================

ALTER TABLE tb_fato_atestados 
ADD COLUMN fk_id_doenca INT,
ADD FOREIGN KEY (fk_id_doenca) REFERENCES tb_dim_doenca(sk_id_doenca);

ALTER TABLE tb_dim_aluno 
ADD COLUMN fk_id_pcd INT,
ADD FOREIGN KEY (fk_id_pcd) REFERENCES tb_dim_perfil_pcd(sk_id_pcd);

-- ============================================
-- VALIDAÇÃO DO ETL: OLTP vs OLAP (FASE 4)
-- ============================================
-- A SOMA das notas e a CONTAGEM de registros devem ser estritamente iguais em ambos os bancos.

-- 1. Validando Transacional (OLTP)
SELECT 
    COUNT(*) AS qtd_notas_oltp, 
    SUM(nota) AS soma_notas_oltp 
FROM creche_db.tb_desempenho;

-- 2. Validando Analítico (OLAP)
SELECT 
    COUNT(*) AS qtd_notas_olap, 
    SUM(nota) AS soma_notas_olap 
FROM creche_dw.tb_fato_desempenho;

-- ============================================
-- INDICES DB --
-- ============================================
USE creche_db;

CREATE INDEX idx_aluno_nome
ON tb_aluno(nome);

CREATE INDEX idx_aluno_data_nascimento
ON tb_aluno(data_nascimento);

CREATE INDEX idx_funcionario_cargo
ON tb_funcionarios(cargo);

CREATE INDEX idx_funcionario_departamento
ON tb_funcionarios(departamento);

CREATE INDEX idx_matricula_status
ON tb_matricula(status);

CREATE INDEX idx_frequencia_aluno_data
ON tb_frequencia_aluno(data_presenca);

CREATE INDEX idx_desempenho_nota
ON tb_desempenho(nota);

CREATE INDEX idx_desempenho_data
ON tb_desempenho(data_avaliacao);

CREATE INDEX idx_salarios_pagamento
ON tb_salarios(data_pagamento);

CREATE INDEX idx_ferias_status
ON tb_ferias(status);

CREATE INDEX idx_aluno_fk_responsavel
ON tb_aluno(fk_responsavel);

CREATE INDEX idx_aluno_fk_responsavel2
ON tb_aluno(fk_responsavel2);

CREATE INDEX idx_aluno_fk_endereco
ON tb_aluno(fk_endereco, fk_numero_endereco);

CREATE INDEX idx_responsavel_fk_endereco
ON tb_responsavel(fk_endereco, fk_numero_endereco);

CREATE INDEX idx_funcionario_fk_endereco
ON tb_funcionarios(fk_endereco, fk_numero_endereco);

CREATE INDEX idx_turma_professor
ON tb_turma(id_professor);

CREATE INDEX idx_matricula_aluno
ON tb_matricula(fk_id_aluno);

CREATE INDEX idx_matricula_turma
ON tb_matricula(fk_id_turma);

CREATE INDEX idx_freq_aluno_fk
ON tb_frequencia_aluno(fk_id_aluno, fk_id_turma);

CREATE INDEX idx_freq_funcionario_fk
ON tb_frequencia_funcionario(fk_id_funcionario);

CREATE INDEX idx_desempenho_aluno
ON tb_desempenho(fk_id_aluno);

CREATE INDEX idx_desempenho_turma
ON tb_desempenho(fk_id_turma);

CREATE INDEX idx_desempenho_disciplina
ON tb_desempenho(fk_id_disciplina);

CREATE INDEX idx_desempenho_funcionario
ON tb_desempenho(fk_id_funcionario);

CREATE INDEX idx_salario_funcionario
ON tb_salarios(fk_id_funcionario);

CREATE INDEX idx_ferias_funcionario
ON tb_ferias(fk_id_funcionario);

CREATE INDEX idx_atestado_aluno
ON tb_atestados(fk_id_aluno);

CREATE INDEX idx_atestado_funcionario
ON tb_atestados(fk_id_funcionario);

-- INDICES DW --

USE creche_dw;

CREATE INDEX idx_fato_desempenho_tempo
ON tb_fato_desempenho(fk_id_tempo);

CREATE INDEX idx_fato_desempenho_aluno
ON tb_fato_desempenho(fk_id_aluno);

CREATE INDEX idx_fato_matricula_tempo
ON tb_fato_matricula(fk_id_tempo);

CREATE INDEX idx_frequencia_funcionario_tempo
ON tb_fato_frequencia_funcionario(fk_id_tempo);

CREATE INDEX idx_frequencia_aluno_tempo
ON tb_fato_frequencia_aluno(fk_id_tempo);

CREATE INDEX idx_financeiro_rh_tempo
ON tb_fato_financeiro_rh(fk_id_tempo);

CREATE INDEX idx_dim_aluno_nk
ON tb_dim_aluno(id_aluno_nk);

CREATE INDEX idx_dim_funcionario_nk
ON tb_dim_funcionario(id_funcionario_nk);

CREATE INDEX idx_dim_turma_codigo
ON tb_dim_turma(codigo_turma);

CREATE INDEX idx_dim_disciplina_codigo
ON tb_dim_disciplina(codigo_disciplina);

CREATE INDEX idx_dim_responsavel_cpf
ON tb_dim_responsavel(cpf_responsavel_nk);

CREATE INDEX idx_dim_tempo_data
ON tb_dim_tempo(data_completa);

-- ============================================
-- INDICES DAS TABELAS FATO
-- ============================================

CREATE INDEX idx_fato_matricula_aluno
ON tb_fato_matricula(fk_id_aluno);

CREATE INDEX idx_fato_matricula_turma
ON tb_fato_matricula(fk_id_turma);

CREATE INDEX idx_fato_matricula_responsavel
ON tb_fato_matricula(fk_id_responsavel);

CREATE INDEX idx_fato_desempenho_disciplina
ON tb_fato_desempenho(fk_id_disciplina);

CREATE INDEX idx_fato_desempenho_funcionario
ON tb_fato_desempenho(fk_id_funcionario);

CREATE INDEX idx_fato_freq_aluno
ON tb_fato_frequencia_aluno(fk_id_aluno);

CREATE INDEX idx_fato_freq_turma
ON tb_fato_frequencia_aluno(fk_id_turma);

CREATE INDEX idx_fato_freq_funcionario
ON tb_fato_frequencia_funcionario(fk_id_funcionario);

CREATE INDEX idx_fato_freq_local
ON tb_fato_frequencia_funcionario(fk_id_local);

CREATE INDEX idx_fato_financeiro_funcionario
ON tb_fato_financeiro_rh(fk_id_funcionario);

CREATE INDEX idx_fato_ferias_funcionario
ON tb_fato_ferias(fk_id_funcionario);

CREATE INDEX idx_fato_atestado_aluno
ON tb_fato_atestados(fk_id_aluno);

CREATE INDEX idx_fato_atestado_funcionario
ON tb_fato_atestados(fk_id_funcionario);

-- ============================================
-- VIEWS --
-- ============================================
-- ============================================
-- MEDIA ALUNOS --
-- ============================================
CREATE VIEW vw_media_alunos AS
SELECT
    a.nome,
    ROUND(AVG(fd.nota),2) AS media_geral
FROM tb_fato_desempenho fd
JOIN tb_dim_aluno a
    ON fd.fk_id_aluno = a.sk_id_aluno
GROUP BY a.nome;

-- ============================================
-- FREQUENCIA ALUNOS --
-- ============================================

CREATE VIEW vw_frequencia_alunos AS
SELECT
    a.nome,
    COUNT(*) AS total_presencas
FROM tb_fato_frequencia_aluno fa
JOIN tb_dim_aluno a
    ON fa.fk_id_aluno = a.sk_id_aluno
WHERE fa.presente_flag = 1
GROUP BY a.nome;

-- ============================================
-- DESEMPENHO DISCIPLINA --
-- ============================================

CREATE VIEW vw_desempenho_disciplinas AS
SELECT
    d.nome_disciplina,
    ROUND(AVG(f.nota),2) AS media_disciplina
FROM tb_fato_desempenho f
JOIN tb_dim_disciplina d
    ON f.fk_id_disciplina = d.sk_id_disciplina
GROUP BY d.nome_disciplina;

-- ============================================
-- CUSTOS RH --
-- ============================================

CREATE VIEW vw_custos_rh AS
SELECT
    f.nome_completo,
    fr.salario_base,
    fr.hora_extra,
    fr.beneficios,
    fr.desconto
FROM tb_fato_financeiro_rh fr
JOIN tb_dim_funcionario f
    ON fr.fk_id_funcionario = f.sk_id_funcionario;
    
-- ============================================
-- FUNCIONARIOS COM FERIAS --
-- ============================================

CREATE VIEW vw_ferias_funcionarios AS
SELECT
    f.nome_completo,
    ff.dias_ferias,
    ff.status_ferias
FROM tb_fato_ferias ff
JOIN tb_dim_funcionario f
    ON ff.fk_id_funcionario = f.sk_id_funcionario;

-- ============================================
-- TABELA DE LOG PARA AUDITORIA --
-- ============================================

USE creche_db;

CREATE TABLE tb_log_matriculas (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    aluno INT,
    turma INT,
    data_matricula DATE,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TRIGGER DE AUTORIA PARA REGISTRO DE NOVAS MATRICULAS --
-- ============================================

DELIMITER //

CREATE TRIGGER trg_log_matricula
AFTER INSERT ON tb_matricula
FOR EACH ROW
BEGIN
    INSERT INTO tb_log_matriculas (
        aluno,
        turma,
        data_matricula
    )
    VALUES (
        NEW.fk_id_aluno,
        NEW.fk_id_turma,
        NEW.data_matricula
    );
END//

DELIMITER ;

-- ============================================
-- TRIGGER DE REGRA DE NEGOCIO PARA IMPEDIR TURMA LOTADA --
-- ============================================

DELIMITER //

CREATE TRIGGER trg_verificar_capacidade_turma
BEFORE INSERT ON tb_matricula
FOR EACH ROW
BEGIN

    DECLARE qtd_alunos INT;
    DECLARE capacidade_turma INT;

    SELECT COUNT(*)
    INTO qtd_alunos
    FROM tb_matricula
    WHERE fk_id_turma = NEW.fk_id_turma
    AND status = 'Ativa';

    SELECT capacidade
    INTO capacidade_turma
    FROM tb_turma
    WHERE pk_id_turma = NEW.fk_id_turma;

    IF qtd_alunos >= capacidade_turma THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Turma lotada';
    END IF;

END//

DELIMITER ;

-- ============================================
-- TRIGGER PARA VALIDAR HORAS --
-- ============================================

DELIMITER //

CREATE TRIGGER trg_validar_horas_funcionario
BEFORE INSERT ON tb_frequencia_funcionario
FOR EACH ROW
BEGIN

    IF NEW.horas_trabalhadas > 24 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Horas trabalhadas inválidas';
    END IF;

END//

DELIMITER ;

-- ============================================
-- STORED PROCEDURE PARA MATRICULA --
-- ============================================

DELIMITER //

CREATE PROCEDURE sp_realizar_matricula(
    IN p_aluno INT,
    IN p_turma INT
)
BEGIN

    INSERT INTO tb_matricula (
        fk_id_aluno,
        fk_id_turma,
        data_matricula,
        status
    )
    VALUES (
        p_aluno,
        p_turma,
        CURDATE(),
        'Ativa'
    );

END//

DELIMITER ;

-- ============================================
-- STORED PROCEDURE PARA CONSULTA DE MEDIA --
-- ============================================

DELIMITER //

CREATE PROCEDURE sp_media_aluno(
    IN p_aluno INT
)
BEGIN

    SELECT
        a.nome,
        ROUND(AVG(d.nota),2) AS media
    FROM tb_desempenho d
    JOIN tb_aluno a
        ON d.fk_id_aluno = a.pk_id_aluno
    WHERE d.fk_id_aluno = p_aluno
    GROUP BY a.nome;

END//

DELIMITER ;

-- ============================================
-- STORED PROCEDURE RELATORIO RH --
-- ============================================

DELIMITER //

CREATE PROCEDURE sp_relatorio_rh()
BEGIN

    SELECT
        f.nome,
        s.salario_base,
        s.hora_extra,
        s.beneficios,
        s.desconto
    FROM tb_salarios s
    JOIN tb_funcionarios f
        ON s.fk_id_funcionario = f.pk_id_funcionario;

END//

DELIMITER ;

-- ============================================
-- ATUALIZACAO AUTOMATICA DE DATA PARA RETORNO DE FERIAS --
-- ============================================

DELIMITER //

CREATE TRIGGER trg_calcular_retorno_ferias
BEFORE INSERT ON tb_ferias
FOR EACH ROW
BEGIN

    SET NEW.data_retorno =
    DATE_ADD(NEW.data_fim, INTERVAL 1 DAY);

END//

DELIMITER ;

-- ============================================
-- IMPEDIR DATA FINAL MENOR QUE INICIAL --
-- ============================================

DELIMITER //

CREATE TRIGGER trg_validar_datas_ferias
BEFORE INSERT ON tb_ferias
FOR EACH ROW
BEGIN

    IF NEW.data_fim < NEW.data_inicio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data final inválida';
    END IF;

END//

DELIMITER ;

-- Validação de Performance
EXPLAIN SELECT * FROM tb_aluno WHERE nome = 'Pedro';

EXPLAIN
SELECT
    a.nome,
    d.nota,
    t.nome_turma
FROM tb_desempenho d
JOIN tb_aluno a
    ON d.fk_id_aluno = a.pk_id_aluno
JOIN tb_turma t
    ON d.fk_id_turma = t.pk_id_turma
WHERE d.nota > 7;

USE creche_dw;

EXPLAIN
SELECT
    da.nome,
    SUM(fd.nota) AS media_total
FROM tb_fato_desempenho fd
JOIN tb_dim_aluno da
    ON fd.fk_id_aluno = da.sk_id_aluno
GROUP BY da.nome;


-- ============================================================================================================================================================
-- DADOS DE EXEMPLO PARA TESTES OLTP -- -- DADOS DE EXEMPLO PARA TESTES OLTP -- -- DADOS DE EXEMPLO PARA TESTES OLTP -- -- DADOS DE EXEMPLO PARA TESTES OLTP -- 
-- ============================================================================================================================================================

-- ============================================
-- DADOS DE EXEMPLO PARA TESTES OLTP
-- ============================================

USE creche_db;

-- Endereco base
INSERT IGNORE INTO tb_endereco (pk_cep, numero, complemento, bairro, cidade, estado)
VALUES ('01001000', 100, 'Apto 1', 'Centro', 'Sao Paulo', 'SP');

-- Responsavel
INSERT IGNORE INTO tb_responsavel 
    (pk_cpf_responsavel, nome, sobrenome, sexo, email, telefone, grau_parentesco, fk_endereco, fk_numero_endereco)
VALUES 
    ('12345678901', 'Maria', 'Silva', 2, 'maria@email.com', '11999999999', 'Mae', '01001000', 100);

-- Alunos
INSERT IGNORE INTO tb_aluno 
    (nome, sobrenome, data_nascimento, raca, sexo, pcd_flag, fk_endereco, fk_numero_endereco, fk_responsavel)
VALUES 
    ('Pedro',  'Silva',    '2020-03-10', 'Branco', 1, FALSE, '01001000', 100, '12345678901'),
    ('Ana',    'Souza',    '2021-06-15', 'Pardo',  2, FALSE, '01001000', 100, '12345678901'),
    ('Lucas',  'Oliveira', '2019-11-22', 'Negro',  1, TRUE,  '01001000', 100, '12345678901');

-- Funcionario (professor)
INSERT IGNORE INTO tb_funcionarios 
    (cpf, nome, sobrenome, data_nascimento, sexo, cargo, departamento, data_admissao, fk_endereco, fk_numero_endereco)
VALUES 
    ('98765432100', 'Carlos', 'Mendes', '1985-04-20', 1, 'Professor', 'Academico', '2022-01-10', '01001000', 100);

-- Turma
INSERT IGNORE INTO tb_turma 
    (nome_turma, serie, turno, sala, ano_letivo, capacidade, id_professor)
VALUES 
    ('Turma A', '1º Ano', 'Manha', 'Sala 01', 2024, 20,
     (SELECT pk_id_funcionario FROM tb_funcionarios WHERE cpf = '98765432100'));

-- Disciplina
INSERT IGNORE INTO tb_disciplina (nome_disciplina, area_conhecimento, carga_horaria)
VALUES 
    ('Matematica',  'Exatas',    40),
    ('Portugues',   'Humanas',   40),
    ('Artes',       'Humanas',   20);

-- ============================================
-- VALIDAÇÃO DE CARGA E IDEMPOTÊNCIA (FASE 2)
-- ============================================
-- Prova de que os INSERTS (usando IGNORE) não duplicaram registros
-- ============================================
-- VALIDAÇÃO DE CARGA E IDEMPOTÊNCIA (FASE 2)
-- ============================================

USE creche_db;

SELECT 'tb_endereco'            AS tabela, COUNT(*) AS total FROM tb_endereco
UNION ALL
SELECT 'tb_responsavel',                   COUNT(*) FROM tb_responsavel
UNION ALL
SELECT 'tb_responsavel2',                  COUNT(*) FROM tb_responsavel2
UNION ALL
SELECT 'tb_aluno',                         COUNT(*) FROM tb_aluno
UNION ALL
SELECT 'tb_alunos_pcd',                    COUNT(*) FROM tb_alunos_pcd
UNION ALL
SELECT 'tb_doencas',                       COUNT(*) FROM tb_doencas
UNION ALL
SELECT 'tb_funcionarios',                  COUNT(*) FROM tb_funcionarios
UNION ALL
SELECT 'tb_turma',                         COUNT(*) FROM tb_turma
UNION ALL
SELECT 'tb_disciplina',                    COUNT(*) FROM tb_disciplina
UNION ALL
SELECT 'tb_matricula',                     COUNT(*) FROM tb_matricula
UNION ALL
SELECT 'tb_frequencia_aluno',              COUNT(*) FROM tb_frequencia_aluno
UNION ALL
SELECT 'tb_frequencia_funcionario',        COUNT(*) FROM tb_frequencia_funcionario
UNION ALL
SELECT 'tb_desempenho',                    COUNT(*) FROM tb_desempenho
UNION ALL
SELECT 'tb_salarios',                      COUNT(*) FROM tb_salarios
UNION ALL
SELECT 'tb_ferias',                        COUNT(*) FROM tb_ferias
UNION ALL
SELECT 'tb_atestados',                     COUNT(*) FROM tb_atestados
UNION ALL
SELECT 'tb_telefone',                      COUNT(*) FROM tb_telefone
UNION ALL
SELECT 'tb_log_matriculas',                COUNT(*) FROM tb_log_matriculas;

-- ============================================
-- CONTROLE TRANSACIONAL
-- ============================================

-- Verificar IDs disponiveis antes de usar
SELECT pk_id_aluno FROM tb_aluno LIMIT 3;
SELECT pk_id_turma FROM tb_turma LIMIT 3;

-- Guardando IDs existentes em variaveis
SET @id_aluno  = (SELECT pk_id_aluno  FROM tb_aluno  LIMIT 1);
SET @id_turma  = (SELECT pk_id_turma  FROM tb_turma  LIMIT 1);
SET @data_test = DATE_ADD(CURDATE(), INTERVAL 999 DAY); -- data ficticia para nao conflitar

-- CENARIO 1: ROLLBACK (simulacao de erro)
START TRANSACTION;

INSERT INTO tb_matricula (fk_id_aluno, fk_id_turma, data_matricula, status)
VALUES (@id_aluno, @id_turma, @data_test, 'Ativa');

ROLLBACK;

-- Validacao: registro NAO deve existir
SELECT COUNT(*) AS deve_ser_zero
FROM tb_matricula
WHERE fk_id_aluno = @id_aluno AND data_matricula = @data_test;


-- CENARIO 2: COMMIT (confirmacao da operacao)
START TRANSACTION;

INSERT INTO tb_matricula (fk_id_aluno, fk_id_turma, data_matricula, status)
VALUES (@id_aluno, @id_turma, @data_test, 'Ativa');

COMMIT;

-- Validacao: registro DEVE existir
SELECT COUNT(*) AS deve_ser_um
FROM tb_matricula
WHERE fk_id_aluno = @id_aluno AND data_matricula = @data_test;


-- CENARIO 3 (diferencial): Multiplas operacoes com ROLLBACK
SET @id_aluno2 = (SELECT pk_id_aluno FROM tb_aluno ORDER BY pk_id_aluno DESC LIMIT 1);
SET @data_test2 = DATE_ADD(CURDATE(), INTERVAL 998 DAY);

START TRANSACTION;

INSERT INTO tb_matricula (fk_id_aluno, fk_id_turma, data_matricula, status)
VALUES (@id_aluno2, @id_turma, @data_test2, 'Ativa');

UPDATE tb_turma
SET capacidade = capacidade - 1
WHERE pk_id_turma = @id_turma;

ROLLBACK;

-- Validacao: nenhuma operacao deve ter persistido
SELECT COUNT(*) AS deve_ser_zero
FROM tb_matricula
WHERE fk_id_aluno = @id_aluno2 AND data_matricula = @data_test2;

SELECT capacidade AS capacidade_inalterada
FROM tb_turma
WHERE pk_id_turma = @id_turma;

-- SUBSELECT AVANCADO 1: Alunos com media acima da media geral
SELECT
    CONCAT(a.nome, ' ', a.sobrenome) AS aluno
FROM tb_aluno a
WHERE a.pk_id_aluno IN (
    SELECT fk_id_aluno
    FROM tb_desempenho
    GROUP BY fk_id_aluno
    HAVING AVG(nota) > (
        SELECT AVG(nota) FROM tb_desempenho
    )
);

-- SUBSELECT AVANCADO 2: Funcionarios que nao tiraram ferias
SELECT
    CONCAT(nome, ' ', sobrenome) AS funcionario
FROM tb_funcionarios
WHERE pk_id_funcionario NOT IN (
    SELECT fk_id_funcionario FROM tb_ferias
);

-- ============================================
-- CONTROLE TRANSACIONAL
-- ============================================

-- CENARIO 1: ROLLBACK (simulacao de erro)
START TRANSACTION;

INSERT INTO tb_matricula (fk_id_aluno, fk_id_turma, data_matricula, status)
VALUES (1, 1, CURDATE(), 'Ativa');

-- Simulando erro: desfazendo a operacao
ROLLBACK;

-- Validacao: registro NAO deve existir
SELECT * FROM tb_matricula WHERE fk_id_aluno = 1 AND data_matricula = CURDATE();


-- CENARIO 2: COMMIT (confirmacao da operacao)
START TRANSACTION;

INSERT INTO tb_matricula (fk_id_aluno, fk_id_turma, data_matricula, status)
VALUES (1, 1, CURDATE(), 'Ativa');

-- Confirmando a operacao
COMMIT;

-- Validacao: registro DEVE existir
SELECT * FROM tb_matricula WHERE fk_id_aluno = 1 AND data_matricula = CURDATE();


-- CENARIO 3 (diferencial): Transacao com multiplas operacoes
START TRANSACTION;

INSERT INTO tb_matricula (fk_id_aluno, fk_id_turma, data_matricula, status)
VALUES (2, 1, CURDATE(), 'Ativa');

UPDATE tb_turma
SET capacidade = capacidade - 1
WHERE pk_id_turma = 1;

-- Simulando erro e revertendo tudo
ROLLBACK;

-- Validacao: nenhuma operacao deve ter persistido
SELECT * FROM tb_matricula WHERE fk_id_aluno = 2 AND data_matricula = CURDATE();
SELECT capacidade FROM tb_turma WHERE pk_id_turma = 1;

-- ============================================
-- CONSULTA ANALÍTICA OLAP (FASE 4 - STAR SCHEMA)
-- ============================================
-- Exemplo de uso do modelo estrela: Total de matrículas ativas por ano e semestre
USE creche_dw;

SELECT 
    dt.ano,
    dt.semestre,
    COUNT(fm.id_fato) AS total_matriculas
FROM tb_fato_matricula fm
JOIN tb_dim_tempo dt 
    ON fm.fk_id_tempo = dt.sk_id_tempo
WHERE fm.status_matricula = 'Ativa'
GROUP BY 
    dt.ano, 
    dt.semestre
ORDER BY 
    dt.ano DESC, 
    dt.semestre DESC;
    
-- ============================================================
-- GRANULARIDADE DAS TABELAS FATO (FASE 4)
-- ============================================================
-- Cada ALTER TABLE abaixo adiciona um comentário à tabela,
-- documentando o significado de cada linha (grão).
-- ============================================================

USE creche_dw;

-- Grão: 1 linha = 1 matrícula de um aluno em uma turma em uma data
ALTER TABLE tb_fato_matricula
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 matricula de um aluno em uma turma em uma data especifica. Chave natural: fk_id_aluno + fk_id_turma + fk_id_tempo.';

-- Grão: 1 linha = 1 avaliação de um aluno em uma disciplina em uma data
ALTER TABLE tb_fato_desempenho
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 avaliacao de um aluno em uma disciplina em uma data especifica. Chave natural: fk_id_aluno + fk_id_disciplina + fk_id_tempo.';

-- Grão: 1 linha = 1 registro de presença/ausência de um aluno em uma turma em um dia
ALTER TABLE tb_fato_frequencia_aluno
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 registro de presenca ou ausencia de um aluno em uma turma em um dia letivo. Chave natural: fk_id_aluno + fk_id_turma + fk_id_tempo.';

-- Grão: 1 linha = 1 registro de ponto de um funcionário em um dia em um local
ALTER TABLE tb_fato_frequencia_funcionario
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 registro de ponto de um funcionario em um dia em um local da creche. Chave natural: fk_id_funcionario + fk_id_tempo + fk_id_local.';

-- Grão: 1 linha = 1 folha de pagamento mensal de um funcionário
ALTER TABLE tb_fato_financeiro_rh
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 competencia de pagamento (mes) para um funcionario. Chave natural: fk_id_funcionario + fk_id_tempo.';

-- Grão: 1 linha = 1 período de férias de um funcionário (início único)
ALTER TABLE tb_fato_ferias
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 periodo de ferias de um funcionario, identificado pela data de inicio. Chave natural: fk_id_funcionario + fk_id_tempo_inicio.';

-- Grão: 1 linha = 1 atestado médico entregue (por aluno OU por funcionário)
ALTER TABLE tb_fato_atestados
    COMMENT = 'GRANULARIDADE: 1 linha representa 1 atestado medico entregue, vinculado a um aluno OU a um funcionario (nunca ambos). Chave natural: fk_id_aluno (ou fk_id_funcionario) + fk_id_tempo_inicio.';


-- ============================================================
-- VALIDAÇÃO COMPLETA DO ETL: OLTP vs OLAP (FASE 4)
-- ============================================================
-- ----------------------------------------------------------
-- 2.1 DESEMPENHO (notas dos alunos da creche)
-- ----------------------------------------------------------
-- OLTP

SELECT
    'OLTP – Desempenho'            AS origem,
    COUNT(*)                        AS qtd_registros,
    ROUND(SUM(nota), 2)             AS soma_notas
FROM creche_db.tb_desempenho;

-- OLAP
SELECT
    'OLAP – Fato Desempenho'        AS origem,
    COUNT(*)                        AS qtd_registros,
    ROUND(SUM(nota), 2)             AS soma_notas
FROM creche_dw.tb_fato_desempenho;


-- ----------------------------------------------------------
-- 2.2 MATRÍCULAS DE ALUNOS
-- ----------------------------------------------------------
-- OLTP
SELECT
    'OLTP – Matriculas'             AS origem,
    COUNT(*)                        AS qtd_registros
FROM creche_db.tb_matricula;

-- OLAP
SELECT
    'OLAP – Fato Matricula'         AS origem,
    COUNT(*)                        AS qtd_registros
FROM creche_dw.tb_fato_matricula;


-- ----------------------------------------------------------
-- 2.3 FREQUÊNCIA DOS ALUNOS
-- ----------------------------------------------------------
-- OLTP
SELECT
    'OLTP – Frequencia Alunos'      AS origem,
    COUNT(*)                        AS qtd_registros,
    SUM(presente_flag)              AS total_presencas,
    SUM(atraso_minutos)             AS total_atrasos_min
FROM creche_db.tb_frequencia_aluno;

-- OLAP
SELECT
    'OLAP – Fato Frequencia Aluno'  AS origem,
    COUNT(*)                        AS qtd_registros,
    SUM(presente_flag)              AS total_presencas,
    SUM(atraso_minutos)             AS total_atrasos_min
FROM creche_dw.tb_fato_frequencia_aluno;


-- ----------------------------------------------------------
-- 2.4 FREQUÊNCIA DOS FUNCIONÁRIOS
-- ----------------------------------------------------------
-- OLTP
SELECT
    'OLTP – Frequencia Funcionarios'        AS origem,
    COUNT(*)                                AS qtd_registros,
    SUM(presente_flag)                      AS total_presencas,
    ROUND(SUM(horas_trabalhadas), 2)        AS total_horas
FROM creche_db.tb_frequencia_funcionario;

-- OLAP
SELECT
    'OLAP – Fato Frequencia Funcionario'    AS origem,
    COUNT(*)                                AS qtd_registros,
    SUM(presente_flag)                      AS total_presencas,
    ROUND(SUM(horas_trabalhadas), 2)        AS total_horas
FROM creche_dw.tb_fato_frequencia_funcionario;


-- ----------------------------------------------------------
-- 2.5 FOLHA FINANCEIRA / RH (salários dos funcionários)
-- ----------------------------------------------------------
-- OLTP
SELECT
    'OLTP – Salarios'                       AS origem,
    COUNT(*)                                AS qtd_registros,
    ROUND(SUM(salario_base), 2)             AS total_salario_base,
    ROUND(SUM(hora_extra), 2)               AS total_hora_extra,
    ROUND(SUM(desconto), 2)                 AS total_descontos,
    ROUND(SUM(beneficios), 2)               AS total_beneficios
FROM creche_db.tb_salarios;

-- OLAP
SELECT
    'OLAP – Fato Financeiro RH'             AS origem,
    COUNT(*)                                AS qtd_registros,
    ROUND(SUM(salario_base), 2)             AS total_salario_base,
    ROUND(SUM(hora_extra), 2)               AS total_hora_extra,
    ROUND(SUM(desconto), 2)                 AS total_descontos,
    ROUND(SUM(beneficios), 2)               AS total_beneficios
FROM creche_dw.tb_fato_financeiro_rh;


-- ----------------------------------------------------------
-- 2.6 FÉRIAS DOS FUNCIONÁRIOS
-- ----------------------------------------------------------
-- OLTP
SELECT
    'OLTP – Ferias'                         AS origem,
    COUNT(*)                                AS qtd_registros,
    ROUND(SUM(abono_ferias), 2)             AS total_abono,
    SUM(DATEDIFF(data_fim, data_inicio))    AS total_dias_ferias
FROM creche_db.tb_ferias;

-- OLAP
SELECT
    'OLAP – Fato Ferias'                    AS origem,
    COUNT(*)                                AS qtd_registros,
    ROUND(SUM(abono_ferias), 2)             AS total_abono,
    SUM(dias_ferias)                        AS total_dias_ferias
FROM creche_dw.tb_fato_ferias;


-- ----------------------------------------------------------
-- 2.7 ATESTADOS (alunos e funcionários da creche)
-- ----------------------------------------------------------
-- OLTP
SELECT
    'OLTP – Atestados'                      AS origem,
    COUNT(*)                                AS qtd_registros,
    SUM(DATEDIFF(data_fim, data_inicio))    AS total_dias_afastamento,
    SUM(fk_id_aluno IS NOT NULL)            AS qtd_atestados_alunos,
    SUM(fk_id_funcionario IS NOT NULL)      AS qtd_atestados_funcionarios
FROM creche_db.tb_atestados;

-- OLAP
SELECT
    'OLAP – Fato Atestados'                 AS origem,
    COUNT(*)                                AS qtd_registros,
    SUM(dias_afastamento)                   AS total_dias_afastamento,
    SUM(fk_id_aluno IS NOT NULL)            AS qtd_atestados_alunos,
    SUM(fk_id_funcionario IS NOT NULL)      AS qtd_atestados_funcionarios
FROM creche_dw.tb_fato_atestados;


-- ============================================================
-- RESUMO CONSOLIDADO DA VALIDAÇÃO ETL
-- ============================================================
-- Usar esta query como evidência final na apresentação.
-- ============================================================

SELECT
    'Desempenho'        AS tabela_fato,
    oltp.qtd            AS qtd_oltp,
    olap.qtd            AS qtd_olap,
    (oltp.qtd - olap.qtd) AS delta_registros,
    oltp.soma           AS soma_oltp,
    olap.soma           AS soma_olap,
    ROUND((oltp.soma - olap.soma), 2) AS delta_valor
FROM
    (SELECT COUNT(*) qtd, ROUND(SUM(nota),2) soma FROM creche_db.tb_desempenho) oltp,
    (SELECT COUNT(*) qtd, ROUND(SUM(nota),2) soma FROM creche_dw.tb_fato_desempenho) olap

UNION ALL

SELECT
    'Matriculas',
    oltp.qtd, olap.qtd, (oltp.qtd - olap.qtd),
    NULL, NULL, NULL
FROM
    (SELECT COUNT(*) qtd FROM creche_db.tb_matricula) oltp,
    (SELECT COUNT(*) qtd FROM creche_dw.tb_fato_matricula) olap

UNION ALL

SELECT
    'Frequencia Alunos',
    oltp.qtd, olap.qtd, (oltp.qtd - olap.qtd),
    oltp.soma, olap.soma, ROUND((oltp.soma - olap.soma), 2)
FROM
    (SELECT COUNT(*) qtd, SUM(presente_flag) soma FROM creche_db.tb_frequencia_aluno) oltp,
    (SELECT COUNT(*) qtd, SUM(presente_flag) soma FROM creche_dw.tb_fato_frequencia_aluno) olap

UNION ALL

SELECT
    'Frequencia Funcionarios',
    oltp.qtd, olap.qtd, (oltp.qtd - olap.qtd),
    oltp.soma, olap.soma, ROUND((oltp.soma - olap.soma), 2)
FROM
    (SELECT COUNT(*) qtd, ROUND(SUM(horas_trabalhadas),2) soma FROM creche_db.tb_frequencia_funcionario) oltp,
    (SELECT COUNT(*) qtd, ROUND(SUM(horas_trabalhadas),2) soma FROM creche_dw.tb_fato_frequencia_funcionario) olap

UNION ALL

SELECT
    'Financeiro RH (Salario Base)',
    oltp.qtd, olap.qtd, (oltp.qtd - olap.qtd),
    oltp.soma, olap.soma, ROUND((oltp.soma - olap.soma), 2)
FROM
    (SELECT COUNT(*) qtd, ROUND(SUM(salario_base),2) soma FROM creche_db.tb_salarios) oltp,
    (SELECT COUNT(*) qtd, ROUND(SUM(salario_base),2) soma FROM creche_dw.tb_fato_financeiro_rh) olap

UNION ALL

SELECT
    'Ferias (Abono)',
    oltp.qtd, olap.qtd, (oltp.qtd - olap.qtd),
    oltp.soma, olap.soma, ROUND((oltp.soma - olap.soma), 2)
FROM
    (SELECT COUNT(*) qtd, ROUND(SUM(abono_ferias),2) soma FROM creche_db.tb_ferias) oltp,
    (SELECT COUNT(*) qtd, ROUND(SUM(abono_ferias),2) soma FROM creche_dw.tb_fato_ferias) olap

UNION ALL

SELECT
    'Atestados',
    oltp.qtd, olap.qtd, (oltp.qtd - olap.qtd),
    oltp.soma, olap.soma, ROUND((oltp.soma - olap.soma), 2)
FROM
    (SELECT COUNT(*) qtd, SUM(DATEDIFF(data_fim,data_inicio)) soma FROM creche_db.tb_atestados) oltp,
    (SELECT COUNT(*) qtd, SUM(dias_afastamento) soma FROM creche_dw.tb_fato_atestados) olap;
    