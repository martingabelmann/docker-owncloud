<?php
${D}CONFIG = array (
    'memcache.local' => '\\OC\\Memcache\\APCu',
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
    )
);
