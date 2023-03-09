<?php

if (
  file_exists(
    dirname(__DIR__) . '/var/cache/prod/App_KernelprodContainer.preload.php'
  )
) {
  require dirname(__DIR__) .
    '/var/cache/prod/App_KernelprodContainer.preload.php';
}
