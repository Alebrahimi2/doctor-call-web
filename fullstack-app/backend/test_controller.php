<?php

require_once 'vendor/autoload.php';

try {
    echo "Testing namespace resolution...\n";
    
    // Test if we can load the class
    $class = new ReflectionClass('App\Http\Controllers\Api\PatientApiController');
    echo "✓ PatientApiController class loaded successfully\n";
    echo "Namespace: " . $class->getNamespaceName() . "\n";
    echo "File: " . $class->getFileName() . "\n";
    
    $class2 = new ReflectionClass('App\Http\Controllers\Api\HospitalApiController');
    echo "✓ HospitalApiController class loaded successfully\n";
    echo "Namespace: " . $class2->getNamespaceName() . "\n";
    echo "File: " . $class2->getFileName() . "\n";
    
} catch (Exception $e) {
    echo "✗ Error: " . $e->getMessage() . "\n";
}