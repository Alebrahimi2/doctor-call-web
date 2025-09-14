<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('patients', function (Blueprint $t) {
            $t->id();
            $t->foreignId('hospital_id')->constrained('hospitals');
            $t->unsignedTinyInteger('severity');
            $t->string('condition_code',30);
            $t->unsignedInteger('triage_priority');
            $t->enum('status',['WAIT','IN_SERVICE','OBS','DONE','DEAD'])->default('WAIT');
            $t->timestamp('eta')->nullable();
            $t->timestamp('wait_since')->nullable();
            $t->timestamps();
            $t->index(['hospital_id','status','triage_priority']);
        });
    }
    public function down() {
        Schema::dropIfExists('patients');
    }
};
