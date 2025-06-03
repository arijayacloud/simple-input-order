<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Karyawan;
use Illuminate\Support\Facades\Auth;

class KaryawanController extends Controller
{
    // Akses publik
    public function publicIndex()
    {
        return response()->json(Karyawan::all());
    }

    // Akses admin (harus login dan bisa dicek role jika perlu)
    public function adminIndex()
    {
        $user = Auth::user();
        // Jika pakai role, bisa tambahkan: if ($user->role !== 'admin') return response()->json(['message' => 'Forbidden'], 403);

        return response()->json(Karyawan::all());
    }

    public function index()
    {
        if (Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        return Karyawan::all();
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required',
            'harga_jual' => 'required|numeric',
            'modal' => 'required|numeric',
        ]);

        $total_profit = $request->harga_jual - $request->modal;

        $karyawan = Karyawan::create([
            'nama' => $request->nama,
            'harga_jual' => $request->harga_jual,
            'modal' => $request->modal,
            'total_profit' => $total_profit,
        ]);

        return response()->json($karyawan, 201);
    }

    public function show(Karyawan $karyawan)
    {
        return $karyawan;
    }

    public function update(Request $request, Karyawan $karyawan)
    {
        $data = $request->all();

        if (isset($data['harga_jual']) && isset($data['modal'])) {
            $data['total_profit'] = $data['harga_jual'] - $data['modal'];
        }

        $karyawan->update($data);
        return $karyawan;
    }

    public function destroy(Karyawan $karyawan)
    {
        $karyawan->delete();
        return response()->noContent();
    }
}

