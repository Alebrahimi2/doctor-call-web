<?php
// resources/lang/en/auth.php

return [
    'login_success' => 'Login successful',
    'login_failed' => 'Invalid login credentials',
    'logout_success' => 'Logout successful',
    'register_success' => 'Account created successfully',
    'profile_updated' => 'Profile updated successfully',
    'password_changed' => 'Password changed successfully',
    'invalid_token' => 'Invalid access token',
    'token_expired' => 'Access token has expired',
    'unauthorized' => 'Unauthorized access',
    'access_denied' => 'Access denied',
    'welcome_subject' => 'Welcome to Doctor Call',
    
    'roles' => [
        'system_admin' => 'System Administrator',
        'hospital_admin' => 'Hospital Administrator',
        'doctor' => 'Doctor',
        'nurse' => 'Nurse',
        'player' => 'Player',
    ],
    
    'validation' => [
        'email_required' => 'Email is required',
        'email_invalid' => 'Invalid email format',
        'password_required' => 'Password is required',
        'password_min' => 'Password must be at least 8 characters',
        'password_confirmation' => 'Password confirmation does not match',
        'name_required' => 'Name is required',
    ],
];