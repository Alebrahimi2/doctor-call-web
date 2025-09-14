<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('staff', function (Blueprint $t) {
            $t->id();
            $t->foreignId('hospital_id')->constrained('hospitals');
            $t->enum('role',['DOCTOR','NURSE','TECH','PHARMACIST','ADMIN','MAINT']);
            $t->unsignedTinyInteger('skill_level')->default(1);
            $t->unsignedTinyInteger('fatigue')->default(0);
            $t->decimal('wage',10,2)->default(0);
            $t->boolean('is_active')->default(true);
            $t->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('staff');
    }
};
