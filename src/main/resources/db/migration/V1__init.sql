create table users
(
    id       SERIAL primary key,
    username text,
    password text,
    email    text,
    enabled  boolean
);
create table roles
(
    id   SERIAL primary key,
    role text
);
create table user_roles
(
    user_id SERIAL,
    role_id int8
);
insert into roles(id, role)
values (1, 'USER'),
       (2, 'ADMIN');

create table project
(
    id               SERIAL primary key,
    name             text not null,
    description      text,
    info             text,
    nmap_initialized boolean default false,
    created timestamp not null,
    updated timestamp
);
create table target
(
    id          SERIAL primary key,
    hostname    text not null,
    description text,
    info        text,
    ip_address  text,
    project_id  bigint references project (id),
    state       text,
    created timestamp not null,
    updated timestamp
);
create table nmap_scan
(
    id         SERIAL primary key,
    start_time bigint,
    status     text
        CONSTRAINT status_enum check (status in ('RUNNING', 'DONE', 'FAILED')),
    project_id bigint references project (id),
    raw text,
    project_run_ordinal integer,
    errors text,
    created timestamp not null,
    updated timestamp
);
create table target_service
(
    id             SERIAL primary key,
    name           text    not null,
    overwritten_name text,
    port           integer not null,
    state          text    not null,
    target_id      bigint references target (id),
    version        text,
    servicefp      text,
    product        text,
    script_outputs text,
    cpe            text,
    format         text,
    protocol       text,
    seen_on_scan_id    bigint references nmap_scan(id),
    created timestamp not null,
    updated timestamp
);

create table script_result
(
    id                SERIAL primary key,
    title              text,
    content            text,
    target_service_id bigint references target_service (id),
    created timestamp not null,
    updated timestamp
);

create table script_result_element
(
    id                    SERIAL primary key,
    key                   text,
    value                 text,
    script_result_id bigint references script_result (id),
    created timestamp not null,
    updated timestamp
);
create table hostname
(
    id        SERIAL primary key,
    hostname  text not null,
    type      text,
    target_id bigint references target (id),
    created timestamp not null,
    updated timestamp
);

create table service_note
(
    id                SERIAL primary key,
    title             text,
    content           text,
    target_service_id bigint references target_service (id),
    created timestamp not null,
    updated timestamp
);


create table nmap_host
(
    id           SERIAL primary key,
    hostname     text not null,
    description  text,
    info         text,
    ip_address   text,
    nmap_scan_id bigint references nmap_scan (id),
    state        text,
    created timestamp not null,
    updated timestamp
);
create table nmap_service
(
    id           SERIAL primary key,
    name         text    not null,
    port         integer not null,
    state        text    not null,
    nmap_host_id bigint references nmap_host (id),
    version      text,
    servicefp    text,
    product      text,
    cpe          text,
    format       text,
    protocol     text,
    created timestamp not null,
    updated timestamp
);
create table nmap_hostname
(
    id           SERIAL primary key,
    hostname     text not null,
    type         text,
    nmap_host_id bigint references nmap_host (id),
    created timestamp not null,
    updated timestamp
);
create table nmap_script_result
(
    id              SERIAL primary key,
    name            text,
    output          text,
    nmap_service_id bigint references nmap_service (id),
    created timestamp not null,
    updated timestamp
);
create table nmap_script_element
(
    id                    SERIAL primary key,
    key                   text,
    value                 text,
    nmap_script_result_id bigint references nmap_script_result (id),
    created timestamp not null,
    updated timestamp
);

create table settings
(
    id    SERIAL primary key,
    name  text not null,
    value text not null,
    created timestamp not null,
    updated timestamp
);
insert into settings(name, value, created)
values ('nmap', '/usr/bin/nmap', now());

insert into settings(name, value, created)
values ('defaultScan', '-Pn -sV -sC -sT', now());
