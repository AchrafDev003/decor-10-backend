<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportMuebles extends Command
{
    protected $signature = 'import:muebles';
    protected $description = 'Importa el SQL de muebles a la base de datos';

    public function handle()
    {
        $path = database_path('sql/muebles(19).sql');

        if (!file_exists($path)) {
            $this->error('Archivo SQL no encontrado');
            return 1;
        }

        $sql = file_get_contents($path);
        DB::unprepared($sql);

        $this->info('Importación completada correctamente');
        return 0;
    }
}
