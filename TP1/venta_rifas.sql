-- auto-generated definition
create table afiliado
(
    id_afiliado           int auto_increment
        primary key,
    nombre                varchar(50) not null,
    apellido              varchar(45) not null,
    dni_afiliado          char(8)     not null,
    domicilio_local       varchar(50) not null,
    domicilio_procedencia varchar(50) null,
    sexo                  varchar(50) null,
    fecha_nacimiento      timestamp   null,
    estado_civil          varchar(50) null,
    tel_contacto          varchar(20) null,
    email                 varchar(50) not null,
    fecha_ingreso         timestamp   null,
    anio_cursa            char(4)     null,
    constraint dni_afiliado
        unique (dni_afiliado)
);

-- auto-generated definition
create table afiliado_grupo
(
    id_afiliado_grupo bigint auto_increment
        primary key,
    dni_afiliado      char(8) not null,
    id_grupo          bigint  not null,
    anio              char(4) not null,
    constraint afiliado_grupo_afiliado_null_fk
        foreign key (dni_afiliado) references afiliado (dni_afiliado),
    constraint afiliado_grupo_grupo_null_fk
        foreign key (id_grupo) references grupo (id_grupo)
);

-- auto-generated definition
create table comprador
(
    dni_comprador char(8)     not null
        primary key,
    nombre        varchar(50) not null,
    apellido      varchar(50) not null,
    domicilio     varchar(50) not null,
    tel_contacto  varchar(20) not null,
    constraint dni_comprador
        unique (dni_comprador)
);

-- auto-generated definition
create table cuota
(
    nro_rifa         varchar(20) not null,
    serie_rifa       varchar(20) not null,
    id_cuota         bigint auto_increment
        primary key,
    fecha_vencimieno timestamp   not null,
    fecha_pago       timestamp   not null,
    id_modo_pago     bigint      not null,
    valor            double      not null,
    constraint cuota_modo_pago_null_fk
        foreign key (id_modo_pago) references modo_pago (id_modo_pago),
    constraint cuota_rifa_null_fk
        foreign key (nro_rifa) references rifa (nro_rifa),
    constraint cuota_rifa_serie_rifa_fk
        foreign key (serie_rifa) references rifa (serie_rifa)
);

-- auto-generated definition
create table grupo
(
    id_grupo     bigint auto_increment
        primary key,
    nombre_grupo varchar(50) not null
);

-- auto-generated definition
create table modo_pago
(
    id_modo_pago bigint auto_increment
        primary key,
    modo_pago    varchar(50) not null
);

-- auto-generated definition
create table rifa
(
    nro_rifa      varchar(20) not null,
    serie_rifa    varchar(20) not null,
    anio          char(4)     not null,
    dni_comprador char(8)     not null,
    id_afiliado   int         not null,
    valor_rifa    double      not null,
    id_rifa       bigint auto_increment
        primary key,
    constraint nro_rifa
        unique (nro_rifa),
    constraint serie_rifa
        unique (serie_rifa),
    constraint rifa_afiliado_null_fk
        foreign key (id_afiliado) references afiliado (id_afiliado),
    constraint rifa_comprador_null_fk
        foreign key (dni_comprador) references comprador (dni_comprador)
);


