<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('missions', function (Blueprint $t) {
            $t->id();
            $t->foreignId('hospital_id')->constrained('hospitals');
            $t->foreignId('template_id')->constrained('mission_templates');
            $t->enum('status',['ACTIVE','SUCCESS','FAIL','EXPIRED'])->default('ACTIVE');
            $t->timestamp('started_at')->useCurrent();
            $t->timestamp('ends_at')->nullable();
            $t->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('missions');
    }
};
