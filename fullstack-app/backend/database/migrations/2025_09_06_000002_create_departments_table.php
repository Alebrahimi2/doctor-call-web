<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('departments', function (Blueprint $t) {
            $t->id();
            $t->foreignId('hospital_id')->constrained('hospitals');
            $t->enum('type',['ER','ICU','OR','RAD','LAB','PHARM','OPD','ADMIN','LOG']);
            $t->unsignedInteger('level')->default(1);
            $t->unsignedInteger('rooms')->default(1);
            $t->unsignedInteger('beds')->default(0);
            $t->unsignedInteger('base_capacity')->default(5);
            $t->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('departments');
    }
};
