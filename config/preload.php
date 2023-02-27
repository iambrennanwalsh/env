<?php

if (file_exists(dirname(__DIR__).'/var/cache/production/App_KernelProductionContainer.preload.php')) {
    require dirname(__DIR__).'/var/cache/production/App_KernelProductionContainer.preload.php';
} elseif (file_exists(dirname(__DIR__).'/var/cache/staging/App_KernelStagingContainer.preload.php')) {
    require dirname(__DIR__).'/var/cache/staging/App_KernelStagingContainer.preload.php';
}
