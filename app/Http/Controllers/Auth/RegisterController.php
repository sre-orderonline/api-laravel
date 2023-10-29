<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class RegisterController extends Controller
{
    public function register(Request $request)
    {
        User::create([
            'name' => $request->input('name'),
            'email' => $request->input('email'), 
            'password' => bcrypt($request->input('password'))
        ]);

        return response()->json(['message' => 'User registered successfully'], 201);
    }
}
