DROP DATABASE IF EXISTS creche_dw;

DROP DATABASE IF EXISTS creche_db;

CREATE DATABASE creche_db;

USE creche_db;

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

CREATE TABLE tb_endereco (
 pk_cep VARCHAR(20),
 numero INT,
 complemento varchar(50),
 bairro VARCHAR(100),
 cidade VARCHAR(100),
 estado CHAR(2),
 PRIMARY KEY (pk_cep, numero)
);

CREATE TABLE tb_telefone (
 pk_id_telefone INT PRIMARY KEY AUTO_INCREMENT,
 pais varchar(20) not null,
 ddd INT,
 numero VARCHAR(20),
 tipo varchar(30)
);

CREATE TABLE tb_responsavel (
 pk_cpf_responsavel CHAR(11) PRIMARY KEY,
 nome VARCHAR(50),
 sobrenome VARCHAR(100),
 sexo INT,
 email VARCHAR(150),
 telefone VARCHAR(30),
 grau_parentesco VARCHAR(50),
 fk_endereco VARCHAR(20),
 fk_numero_endereco INT,
 FOREIGN KEY (sexo) REFERENCES tb_sexo_enum(id),
 FOREIGN KEY (fk_endereco, fk_numero_endereco)
 REFERENCES tb_endereco(pk_cep, numero)
);

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

CREATE TABLE tb_disciplina (
 pk_id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
 nome_disciplina VARCHAR(150),
 area_conhecimento VARCHAR(100),
 carga_horaria INT
);

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

CREATE TABLE tb_frequencia_funcionario (
 PRIMARY KEY (fk_id_funcionario, data_presenca),
 fk_id_funcionario INT,
 data_presenca DATE,
 presente_flag BOOLEAN NOT NULL CHECK (presente_flag IN (0,1)),
 horas_trabalhadas DECIMAL(5,2) DEFAULT 0,
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario) ON DELETE RESTRICT
);

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

CREATE TABLE tb_salarios (
 id_salario INT PRIMARY KEY AUTO_INCREMENT,
 fk_id_funcionario INT,
 data_pagamento DATE,
 salario_base DECIMAL(12,2),
 hora_extra DECIMAL(12,2),
 desconto DECIMAL(12,2),
 beneficios DECIMAL(12,2),
 FOREIGN KEY (fk_id_funcionario)
 REFERENCES tb_funcionarios(pk_id_funcionario) ON DELETE RESTRICT
);

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

CREATE DATABASE creche_dw;

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

INSERT INTO tb_dim_tempo (
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

INSERT INTO tb_dim_aluno (
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
 
INSERT INTO tb_dim_responsavel (
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
 ON r.fk_endereco = e.pk_cep;
 
INSERT INTO tb_dim_funcionario (
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
 
INSERT INTO tb_dim_turma (
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

INSERT INTO tb_dim_disciplina (
 codigo_disciplina,
 nome_disciplina
)
SELECT
 pk_id_disciplina,
 nome_disciplina
FROM creche_db.tb_disciplina;

INSERT INTO tb_dim_local (
 unidade,
 sala,
 cidade
)
SELECT DISTINCT
 'Creche Central',
 sala,
 'Sao Paulo'
FROM creche_db.tb_turma;

INSERT INTO tb_fato_matricula (
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
 
INSERT INTO tb_fato_desempenho (
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
 
INSERT INTO tb_fato_frequencia_aluno (
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
 
INSERT INTO tb_fato_frequencia_funcionario (
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

INSERT INTO tb_fato_financeiro_rh (
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
 
INSERT INTO tb_fato_ferias (
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
 
INSERT INTO tb_fato_atestados (
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