<?php
${D}CONFIG = array (
    'apps_paths' => array (
        0 => array (
            "path"     => "$OC_WWW/apps",
            "url"      => "/apps",
            "writable" => false,
        ),
        1 => array (
            "path"     => "$OC_WWW/apps2",
            "url"      => "/apps2",
            "writable" => true,
        )
    ),
    'trusted_domains' => array ($OC_TRUSTED_DOMAINS),
    'datadirectory' => '$OC_DATADIR',
    'default_language' => '$OC_LANGUAGE',
    'defaultapp' => '$OC_DEFAULTAPP',
    'overwritehost' => '$OC_OVERWRITEHOST',
    'loglevel' => $OC_LOGLEVEL,
    'mail_from_address' => '$OC_MAIL_FROM_ADDRESS',
    'mail_smtpmode' => '$OC_MAIL_SMTPMODE',
    'mail_domain' => '$OC_MAIL_DOMAIN',
    'mail_smtpauthtype' => '$OC_MAIL_SMTPAUTHTYPE',
    'mail_smtpauth' => $OC_MAIL_SMTPAUTH,
    'mail_smtphost' => '$OC_MAIL_SMTPHOST',
    'mail_smtpport' => '$OC_MAIL_SMTPPORT',
    'mail_smtpname' => '$OC_MAIL_SMTPNAME',
    'mail_smtpsecure' => '$OC_MAIL_SMTPSECURE',
    'mail_smtppassword' => '$OC_MAIL_SMTPPASSWORD',
    'memcache.local' => '\\OC\\Memcache\\APCu',
);
