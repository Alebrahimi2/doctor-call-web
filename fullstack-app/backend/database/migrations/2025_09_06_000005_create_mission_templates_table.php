<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('mission_templates', function (Blueprint $t) {
            $t->id();
            $t->string('code',40)->unique();
            $t->string('name',120);
            $t->unsignedInteger('min_level')->default(1);
            $t->json('requirements_json');
            $t->json('rewards_json');
            $t->unsignedInteger('duration_sec')->default(600);
            $t->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('mission_templates');
    }
};
