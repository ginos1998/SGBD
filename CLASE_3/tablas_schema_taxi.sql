-- auto-generated definition
create table autos
(
    patente   varchar(7)                       not null
        primary key,
    color     enum ('rojo', 'negro', 'blanco') not null,
    id_modelo int                              not null,
    anio      year                             not null,
    itv_vence date                             null,
    constraint fk_id_modelo
        foreign key (id_modelo) references modelo (id_modelo)
);

-- auto-generated definition
create table choferes
(
    dni           char(8)     not null
        primary key,
    nro_licencia  varchar(50) not null,
    sueldo        float       not null,
    choferes_col  varchar(50) null,
    fecha_ingreso datetime    not null,
    constraint choferes_personas_null_fk
        foreign key (dni) references personas (dni)
);

-- auto-generated definition
create table cliente
(
    dni        char(8)  not null
        primary key,
    fecha_alta datetime not null,
    constraint cliente_personas_null_fk
        foreign key (dni) references personas (dni)
);

-- auto-generated definition
create table estado
(
    id_estado int auto_increment
        primary key
);

-- auto-generated definition
create table estado_viajes
(
    id_estado        int not null,
    id_viaje         int not null,
    id_estado_viajes int auto_increment
        primary key,
    constraint fk_id_estado
        foreign key (id_estado) references estado (id_estado),
    constraint fk_id_viajes
        foreign key (id_viaje) references viajes (id_viajes)
);

-- auto-generated definition
create table marca
(
    id_marca int auto_increment
        primary key,
    marca    int not null
);

-- auto-generated definition
create table modelo
(
    id_modelo int auto_increment
        primary key,
    modelo    varchar(45) not null,
    id_marca  int         not null,
    constraint fk_id_marca
        foreign key (id_marca) references marca (id_marca)
);

-- auto-generated definition
create table personas
(
    dni              char(8)      not null
        primary key,
    nombre           varchar(50)  not null,
    apellido         varchar(50)  not null,
    domicilio        varchar(100) null,
    fecha_nacimiento datetime     null
);

-- auto-generated definition
create table viajes
(
    id_viajes      int auto_increment
        primary key,
    latitud_inicio float      null,
    latitud_fin    float      null,
    long_inicio    float      null,
    long_fin       float      null,
    fecha_inicio   datetime   null,
    fecha_fin      datetime   null,
    dni_chofer     char(8)    not null,
    dni_cliente    char(8)    not null,
    patente        varchar(7) not null,
    constraint fk_patente
        foreign key (patente) references autos (patente)
);


