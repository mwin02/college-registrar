-- "dtype": "static",
--         "url": "http://localhost:5500/",
--         "referrer": "",
--         "timestamp": "2023-05-16T01:16:29.936Z",
--         "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
--         "screenDimensions": {
--             "width": 1536,
--             "height": 960
--         },
--         "windowDimensions": {
--             "width": 1536,
--             "height": 797
--         },
--         "language": "en-US",
--         "cookies-en": true,
--         "js-en": true,
--         "image-en": true,
--         "css-en": true,
--         "connection": "4g",
--         "uuid": "3dfefca4-76ef-48e1-b20e-8099b629ebf8"
create table static(
  entry_id SERIAL,
  url varchar(255),
  referrer varchar(255),
  timestamp varchar(255),
  user_agent varchar(255),
  screen_width int,
  screen_height int,
  window_width int,
  window_height int,
  language varchar(50),
  cookie_en boolean,
  javascript_en boolean,
  image_en boolean,
  css_en boolean,
  connection varchar(10),
  uuid varchar(50),
  primary key (entry_id)
)

-- {"dtype":"performance","loadStart":389.7999999523163,"loadEnd":579.5,"loadTime":189.70000004768372,"uuid":"f887bc0f-3f20-475e-9f82-f4d8d3908240"}

create table performance(
  entry_id SERIAL,
  load_start float,
  load_end float,
  load_time float,
  uuid varchar(50),
  primary key (entry_id)
)

create table activity(
  entry_id SERIAL,
  current_page varchar(255),
  time varchar(255),
  uuid varchar(50),
  primary key (entry_id)
)

-- (activity_id, type, button, x, y, scroll, time)

create table event(
  activity_id BIGINT UNSIGNED,
  type varchar(255),
  button varchar(255),
  x int,
  y int,
  scroll int,
  time float,
  foreign key (activity_id) references activity(entry_id) ON DELETE CASCADE
)

create table idle(
  activity_id BIGINT UNSIGNED,
  start varchar(255),
  end varchar(255),
  length float,
  primary key (activity_id, start, end),
  foreign key (activity_id) references activity(entry_id) ON DELETE CASCADE
)
