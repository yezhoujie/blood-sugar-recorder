-- 用户表.
CREATE TABLE users
(
    id       INTEGER PRIMARY KEY NOT NULL, -- 主键ID
    name     TEXT                NOT NULL, -- 用户姓名
    gender   TEXT                NOT NULL, -- 用户性别
    birthday TEXT                NOT NULL  -- 用户生日
);
-- 用户血糖指标配置表.
CREATE TABLE user_blood_sugar_config
(
    user_id  INTEGER PRIMARY KEY NOT NULL, -- 用户关联id, 主键
    fpg_min  REAL                NOT NULL, -- 空腹血糖指标下限，低于该值为低血糖
    fpg_max  REAL                NOT NULL, -- 空腹须糖指标上限，高于该值为高血糖
    hpg2_min REAL                NOT NULL, -- 餐后两小时血糖指标下限，低于该值为低血糖
    hpg2_max REAL                NOT NULL  -- 餐后两小时血糖指标上限, 高于该值为高血糖
);
-- 用户药物配置表
CREATE TABLE user_medicine_config
(
    id      INTEGER PRIMARY KEY NOT NULL, -- 主键ID
    user_id INTEGER             NOT NULL, -- 用户关联id, 主键
    type    TEXT                NOT NULL, -- 药物类型,INS:胰岛素,PILL:降血糖药
    name    TEXT                NOT NULL, -- 药物名称
    color   TEXT                NOT NULL, -- 显示颜色
    unit    TEXT                NOT NULL  -- 单位名称
);
-- 创建用户ID索引
CREATE INDEX medicine_config_user_id_index ON user_medicine_config (user_id);


-- 血糖检测周期记录表,基本以（1.注射胰岛素或药物干预, 2:进食, 3:2小时后或第二天空腹测试血糖为一个周期）
-- 周期开始与结束由用户决定
CREATE TABLE cycle_record
(
    id       INTEGER PRIMARY KEY NOT NULL, -- 主键id
    user_id  INTEGER             NOT NULL, -- 关联用户id
    datetime TEXT,                         -- 周期所在时间，以周期内最后一次血糖记录时间为准
    closed   INTEGER             NOT NULL  -- 该周期是否关闭，0:false, 1:true
);
-- 创建周期表用户id索引
CREATE INDEX cycle_record_user_id_index ON cycle_record (user_id);
-- 用户id索引

-- 创建周期表周期时间索引
CREATE INDEX cycle_record_date_index ON cycle_record (datetime);
-- 时间索引


-- 创建药物干预记录表.
CREATE TABLE medicine_record_item
(
    id              INTEGER PRIMARY KEY NOT NULL, -- 主键ID
    cycle_record_id INTEGER             NOT NULL, -- 关联周期ID
    medicine_id     INTEGER             NOT NULL, -- 药物ID
    `usage`         REAL                NOT NULL, -- 药物用量
    record_time     TEXT                NOT NULL, -- 记录时间
    extra           INTEGER             NOT NULL  -- 是否进行额外药物补充
);

-- 创建周期id索引
CREATE INDEX medicine_record_item_cycle_record_id_index on medicine_record_item (cycle_record_id);
-- 记录周期id索引

-- 创建记录时间索引
CREATE INDEX medicine_record_item_record_time_index on medicine_record_item (record_time);
-- 记录时间索引

-- 创建额外药物补充索引
CREATE INDEX extra_index on medicine_record_item (extra);
-- 是否进行额外药物补充索引


-- 创建进食记录表.
CREATE TABLE food_record_item
(
    id              INTEGER PRIMARY KEY NOT NULL, -- 主键ID
    cycle_record_id INTEGER             NOT NULL, -- 关联周期ID
    food_info       TEXT                NOT NULL, -- 食物清单
    comment         TEXT                NOT NULL, -- 进食备注
    record_time     TEXT                NOT NULL  -- 记录时间
);

-- 创建周期id索引
CREATE INDEX food_record_item_cycle_record_id_index on food_record_item (cycle_record_id);
-- 记录周期id索引

-- 创建记录时间索引
CREATE INDEX food_record_item_record_time_index on food_record_item (record_time);
-- 记录时间索引


-- 创建血糖测试记录表
CREATE TABLE blood_sugar_record_item
(
    id              INTEGER PRIMARY KEY NOT NULL, -- 主键ID
    cycle_record_id INTEGER             NOT NULL, -- 关联周期ID
    blood_sugar     REAL                NOT NULL, -- 血糖
    record_time     TEXT                NOT NULL  -- 记录时间
);
-- 创建周期id索引
CREATE INDEX blood_sugar_record_item_cycle_record_id_index on blood_sugar_record_item (cycle_record_id);
-- 记录周期id索引

-- 创建记录时间索引
CREATE INDEX blood_sugar_record_item_record_time_index on blood_sugar_record_item (record_time);