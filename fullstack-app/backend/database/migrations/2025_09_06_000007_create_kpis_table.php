<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('kpis', function (Blueprint $t) {
            $t->id();
            $t->foreignId('hospital_id')->constrained('hospitals');
            $t->date('date');
            $t->decimal('avg_wait_min',6,2)->default(0);
            $t->decimal('service_rate',6,2)->default(0);
            $t->decimal('occupancy',5,2)->default(0);
            $t->decimal('satisfaction',5,2)->default(100);
            $t->timestamps();
            $t->unique(['hospital_id','date']);
        });
    }
    public function down() {
        Schema::dropIfExists('kpis');
    }
};
