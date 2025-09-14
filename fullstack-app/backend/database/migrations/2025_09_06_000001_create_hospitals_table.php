<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('hospitals', function (Blueprint $t) {
            $t->id();
            $t->foreignId('owner_user_id')->constrained('users');
            $t->string('name',120);
            $t->unsignedInteger('level')->default(1);
            $t->unsignedInteger('reputation')->default(0);
            $t->decimal('cash',12,2)->default(100000);
            $t->unsignedBigInteger('soft_currency')->default(0);
            $t->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('hospitals');
    }
};
