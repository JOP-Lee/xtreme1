SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ontology_id` bigint(20) NOT NULL,
  `name` varchar(256) NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  `tool_type` enum('POLYGON','BOUNDING_BOX','POLYLINE','KEY_POINT','SEGMENTATION','CUBOID') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `tool_type_options` json DEFAULT NULL,
  `attributes` json DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ontology_id_name_tool_type` (`ontology_id`,`name`,`tool_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for classification
-- ----------------------------
DROP TABLE IF EXISTS `classification`;
CREATE TABLE `classification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ontology_id` bigint(20) NOT NULL,
  `name` varchar(256) NOT NULL,
  `is_required` bit(1) NOT NULL DEFAULT b'0',
  `input_type` enum('RADIO','TEXT','MULTI_SELECTION','DROPDOWN') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `options` json DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ontology_id_name` (`ontology_id`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for data
-- ----------------------------
DROP TABLE IF EXISTS `data`;
CREATE TABLE `data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `dataset_id` bigint(20) DEFAULT NULL COMMENT 'Dataset id',
  `name` varchar(255) DEFAULT NULL COMMENT 'Data name',
  `content` json DEFAULT NULL COMMENT 'Content (folder path, version information)',
  `status` enum('INVALID','VALID') DEFAULT 'VALID' COMMENT 'Data status INVALID,VALID',
  `annotation_status` enum('ANNOTATED','NOT_ANNOTATED','INVALID') DEFAULT 'NOT_ANNOTATED' COMMENT 'Data annotation status ANNOTATED, NOT_ANNOTATED, INVALID',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Is deleted',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dataset_id_type_created_at` (`dataset_id`,`created_at`) USING BTREE,
  KEY `idx_dataset_id_type_annotation_count` (`dataset_id`) USING BTREE,
  KEY `idx_dataset_id_type` (`dataset_id`) USING BTREE,
  KEY `idx_dataset_id_type_num_created_at` (`dataset_id`,`created_at`) USING BTREE,
  KEY `idx_dataset_id_type_num_annotation_count` (`dataset_id`) USING BTREE,
  KEY `idx_dataset_id_type_name` (`dataset_id`,`name`) USING BTREE,
  KEY `idx_dataset_id_type_num_name` (`dataset_id`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Data';

-- ----------------------------
-- Table structure for data_annotation
-- ----------------------------
DROP TABLE IF EXISTS `data_annotation`;
CREATE TABLE `data_annotation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) DEFAULT NULL,
  `data_id` bigint(20) DEFAULT NULL,
  `classification_id` bigint(20) DEFAULT NULL,
  `classification_attributes` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for data_annotation_classification
-- ----------------------------
DROP TABLE IF EXISTS `data_annotation_classification`;
CREATE TABLE `data_annotation_classification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) DEFAULT NULL,
  `data_id` bigint(20) DEFAULT NULL,
  `classification_id` bigint(20) DEFAULT NULL,
  `classification_attributes` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for data_annotation_object
-- ----------------------------
DROP TABLE IF EXISTS `data_annotation_object`;
CREATE TABLE `data_annotation_object` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) DEFAULT NULL,
  `data_id` bigint(20) DEFAULT NULL,
  `class_id` bigint(20) DEFAULT NULL,
  `class_attributes` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for data_annotation_record
-- ----------------------------
DROP TABLE IF EXISTS `data_annotation_record`;
CREATE TABLE `data_annotation_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `dataset_id` bigint(20) NOT NULL COMMENT 'Dataset id',
  `serial_no` bigint(20) DEFAULT NULL COMMENT 'Serial number',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dataset_id_created_by` (`dataset_id`,`created_by`) USING BTREE COMMENT 'dataset_id,created_by unique index'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Data annotation record';

-- ----------------------------
-- Table structure for data_classification_option
-- ----------------------------
DROP TABLE IF EXISTS `data_classification_option`;
CREATE TABLE `data_classification_option` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `dataset_id` bigint(20) NOT NULL COMMENT 'Dataset id',
  `data_id` bigint(20) NOT NULL COMMENT 'Data id',
  `classification_id` bigint(20) NOT NULL COMMENT 'Classification_id',
  `attribute_id` varchar(50) NOT NULL COMMENT 'The attribute id of classification',
  `option_name` varchar(255) NOT NULL COMMENT 'The option name of classification',
  `option_path` json NOT NULL COMMENT 'The path of selected options of classification',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_attribute_id` (`attribute_id`) USING BTREE,
  KEY `idx_dataset_id` (`dataset_id`) USING BTREE,
  KEY `idx_data_id` (`data_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for data_edit
-- ----------------------------
DROP TABLE IF EXISTS `data_edit`;
CREATE TABLE `data_edit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `annotation_record_id` bigint(20) DEFAULT NULL COMMENT 'Data annotation record id',
  `dataset_id` bigint(20) NOT NULL COMMENT 'Dataset id',
  `data_id` bigint(20) NOT NULL COMMENT 'Data id',
  `model_id` bigint(20) DEFAULT NULL COMMENT 'Model id',
  `model_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Model version',
  `created_by` bigint(20) NOT NULL COMMENT 'Creator id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_data_id` (`data_id`) USING BTREE COMMENT 'data_id unique index'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Data edit';

-- ----------------------------
-- Table structure for dataset
-- ----------------------------
DROP TABLE IF EXISTS `dataset`;
CREATE TABLE `dataset` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) NOT NULL COMMENT 'Dataset name',
  `type` enum('LIDAR_FUSION','LIDAR_BASIC','IMAGE') NOT NULL DEFAULT 'LIDAR_FUSION' COMMENT 'Dataset type LIDAR_FUSION,LIDAR_BASIC,IMAGE',
  `description` text COMMENT 'Dataset description',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Is deleted',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Dataset';

-- ----------------------------
-- Table structure for dataset_class
-- ----------------------------
DROP TABLE IF EXISTS `dataset_class`;
CREATE TABLE `dataset_class` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) NOT NULL,
  `name` varchar(256) NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  `tool_type` enum('POLYGON','BOUNDING_BOX','POLYLINE','KEY_POINT','SEGMENTATION','CUBOID') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `tool_type_options` json DEFAULT NULL,
  `attributes` json DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dataset_id_name` (`dataset_id`,`name`,`tool_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for dataset_class_ontology
-- ----------------------------
DROP TABLE IF EXISTS `dataset_class_ontology`;
CREATE TABLE `dataset_class_ontology` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_class_id` bigint(20) NOT NULL COMMENT 'id of class in dataset',
  `ontology_id` bigint(20) NOT NULL COMMENT 'id of related ontology ',
  `class_id` bigint(20) NOT NULL COMMENT 'id of related class in ontology',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dataset_class_id` (`dataset_class_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='dataset class和ontology中的class关联表';

-- ----------------------------
-- Table structure for dataset_classification
-- ----------------------------
DROP TABLE IF EXISTS `dataset_classification`;
CREATE TABLE `dataset_classification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) NOT NULL,
  `name` varchar(256) NOT NULL,
  `is_required` bit(1) NOT NULL DEFAULT b'0',
  `input_type` enum('RADIO','TEXT','MULTI_SELECTION','DROPDOWN') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `options` json DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dataset_id_name` (`dataset_id`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for dataset_similarity_job
-- ----------------------------
DROP TABLE IF EXISTS `dataset_similarity_job`;
CREATE TABLE `dataset_similarity_job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dataset_id` (`dataset_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for dataset_similarity_record
-- ----------------------------
DROP TABLE IF EXISTS `dataset_similarity_record`;
CREATE TABLE `dataset_similarity_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dataset_id` bigint(20) NOT NULL,
  `serial_number` varchar(32) NOT NULL,
  `status` enum('COMPLETED','ERROR','SUBMITTED') NOT NULL,
  `type` enum('FULL','INCREMENT') DEFAULT NULL,
  `data_info` json NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_dataset_id` (`dataset_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for export_record
-- ----------------------------
DROP TABLE IF EXISTS `export_record`;
CREATE TABLE `export_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `serial_number` bigint(40) NOT NULL COMMENT 'Serial number',
  `file_id` bigint(20) DEFAULT NULL COMMENT 'File id',
  `file_name` varchar(100) DEFAULT NULL COMMENT 'File name',
  `generated_num` int(11) DEFAULT '0' COMMENT 'Generated number',
  `total_num` int(11) DEFAULT NULL COMMENT 'Export total number',
  `status` enum('UNSTARTED','GENERATING','COMPLETED','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'UNSTARTED' COMMENT 'Export status(UNSTARTED,GENERATING,COMPLETED,FAILED)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unx_serial_number` (`serial_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for file
-- ----------------------------
DROP TABLE IF EXISTS `file`;
CREATE TABLE `file` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) NOT NULL COMMENT 'File name',
  `original_name` varchar(255) NOT NULL COMMENT 'File original name',
  `path` varchar(1000) NOT NULL COMMENT 'File upload path',
  `path_hash` bigint(64) DEFAULT NULL COMMENT 'Hash value after path MD5',
  `zip_path` varchar(1000) DEFAULT NULL COMMENT 'The path in the compressed package',
  `type` varchar(50) DEFAULT NULL COMMENT 'File type',
  `size` bigint(20) DEFAULT NULL COMMENT 'File size',
  `bucket_name` varchar(50) DEFAULT NULL COMMENT 'Bucket name',
  `relation_id` bigint(20) DEFAULT NULL COMMENT 'Relation file id',
  `relation` enum('LARGE_THUMBTHUMBNAIL','MEDIUM_THUMBTHUMBNAIL','SMALL_THUMBTHUMBNAIL','BINARY','BINARY_COMPRESSED','POINT_CLOUD_RENDER_IMAGE') CHARACTER SET utf8 DEFAULT NULL COMMENT 'Relation(LARGE_THUMBTHUMBNAIL, MEDIUM_THUMBTHUMBNAIL,SMALL_THUMBTHUMBNAIL,BINARY,BINARY_COMPRESSED)',
  `extra_info` json DEFAULT NULL COMMENT 'File extension information',
  `created_at` datetime DEFAULT NULL COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_path_hash` (`path_hash`) USING BTREE,
  KEY `idx_relation_id` (`relation_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='File table';

-- ----------------------------
-- Table structure for model
-- ----------------------------
DROP TABLE IF EXISTS `model`;
CREATE TABLE `model` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `description` text,
  `scenario` varchar(128) DEFAULT NULL COMMENT 'Scenes',
  `classes` json DEFAULT NULL COMMENT 'Class that this model can identify',
  `dataset_type` enum('LIDAR_FUSION','LIDAR_BASIC','IMAGE','LIDAR') DEFAULT NULL COMMENT 'Dataset types supported by this model',
  `model_code` enum('PRE_LABEL','COCO_80') DEFAULT NULL COMMENT 'Model''s unique identifier',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0',
  `created_at` datetime NOT NULL,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for model_data_result
-- ----------------------------
DROP TABLE IF EXISTS `model_data_result`;
CREATE TABLE `model_data_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `model_id` bigint(20) NOT NULL COMMENT 'Model id',
  `model_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Model version',
  `dataset_id` bigint(20) NOT NULL COMMENT 'Dataset id',
  `data_id` bigint(20) NOT NULL COMMENT 'Data id',
  `model_serial_no` bigint(20) DEFAULT NULL COMMENT 'Serial number',
  `result_filter_param` json DEFAULT NULL COMMENT 'Model results filtering parameters',
  `model_result` json DEFAULT NULL COMMENT 'The result returned by running the model',
  `created_at` datetime NOT NULL COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_model_serial_no_data_id` (`model_serial_no`,`data_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Data model result';

-- ----------------------------
-- Table structure for model_job
-- ----------------------------
DROP TABLE IF EXISTS `model_job`;
CREATE TABLE `model_job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `model_serial_no` bigint(20) NOT NULL COMMENT 'Model running serial number',
  `model_code` enum('PRE_LABEL','COCO80') NOT NULL COMMENT 'Model code',
  `job_params` json DEFAULT NULL COMMENT 'Job parameter',
  `job_status` enum('COMMITED','RUNNING','DONE','FAILED') NOT NULL COMMENT 'Job status',
  `created_at` datetime NOT NULL COMMENT 'Create time',
  `created_by` bigint(20) NOT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1  DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for ontology
-- ----------------------------
DROP TABLE IF EXISTS `ontology`;
CREATE TABLE `ontology` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `type` enum('LIDAR_FUSION','LIDAR_BASIC','IMAGE') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'dataset type',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name_type` (`name`,`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for upload_record
-- ----------------------------
DROP TABLE IF EXISTS `upload_record`;
CREATE TABLE `upload_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `serial_number` bigint(40) NOT NULL COMMENT 'Serial number',
  `file_url` varchar(1000) DEFAULT NULL COMMENT 'File url',
  `file_name` varchar(255) DEFAULT NULL COMMENT 'File name',
  `error_message` longtext COMMENT 'Error information',
  `total_file_size` bigint(20) DEFAULT NULL COMMENT 'Total file size',
  `downloaded_file_size` bigint(20) DEFAULT NULL COMMENT 'Downloaded file size',
  `total_data_num` bigint(20) DEFAULT NULL COMMENT 'The total number of data',
  `parsed_data_num` bigint(20) DEFAULT NULL COMMENT 'Number of parsed data',
  `status` enum('UNSTARTED','DOWNLOADING','DOWNLOAD_COMPLETED','PARSING','PARSE_COMPLETED','FAILED') DEFAULT 'UNSTARTED' COMMENT 'Upload status',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unx_serial_number` (`serial_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `username` varchar(64) DEFAULT NULL COMMENT 'login username',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT 'encode password',
  `nickname` varchar(50) DEFAULT NULL COMMENT 'user nickname',
  `avatar_id` bigint(20) DEFAULT NULL COMMENT 'avatar id. file table primary key',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'user created time',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'user updated time',
  `last_login_at` datetime DEFAULT NULL COMMENT 'last login time',
  `status` enum('NORMAL','FORBIDDEN') DEFAULT 'NORMAL' COMMENT 'the status of user',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='User table';

-- ----------------------------
-- Table structure for user_token
-- ----------------------------
DROP TABLE IF EXISTS `user_token`;
CREATE TABLE `user_token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `token` varchar(255) NOT NULL COMMENT 'token',
  `token_type` enum('API','GATEWAY') NOT NULL COMMENT 'token type',
  `expire_at` datetime DEFAULT NULL COMMENT 'token expire datetime',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `created_by` bigint(20) DEFAULT NULL COMMENT 'Creator id',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `updated_by` bigint(20) DEFAULT NULL COMMENT 'Modify person id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_created_by` (`created_by`) USING BTREE,
  KEY `idx_token` (`token`(90))
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
