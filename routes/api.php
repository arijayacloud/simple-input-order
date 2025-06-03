<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\KaryawanController;
use App\Http\Controllers\Api\AuthController;

Route::post('/login', [AuthController::class, 'login']);

// 📌 Akses umum: TANPA login (karyawan bisa lihat dan tambah data)
Route::get('/karyawans', [KaryawanController::class, 'publicIndex']);
Route::post('/karyawans', [KaryawanController::class, 'store']);

// 🔐 Akses admin: HARUS login dan role = admin
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/admin/karyawans', [KaryawanController::class, 'adminIndex']);
    Route::get('/karyawans/export', [KaryawanController::class, 'export']);
});

Route::options('/{any}', function () {
    return response()->json([], 204);
})->where('any', '.*');


// ✅ Route test juga tidak butuh auth
Route::get('/test', function () {
    return response()->json(['message' => 'API Working!']);
});