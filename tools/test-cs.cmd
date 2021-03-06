@echo off
REM Copyright (c) 2016-2017 Vegard IT GmbH, http://vegardit.com
REM SPDX-License-Identifier: Apache-2.0
REM Author: Sebastian Thomschke, Vegard IT GmbH

pushd .

REM cd into project root
cd %~dp0..

echo Cleaning...
if exist dump\cs rd /s /q dump\cs
if exist target\cs rd /s /q target\cs

haxelib list | findstr haxe-doctest >NUL
if errorlevel 1 (
    echo Installing [haxe-doctest]...
    haxelib install haxe-doctest
)

haxelib list | findstr hxcs >NUL
if errorlevel 1 (
    echo Installing [hxcs]...
    haxelib install hxcs
)

echo Compiling...
haxe -main hx.strings.TestRunner ^
  -lib haxe-doctest ^
  -cp src ^
  -cp test ^
  -dce full ^
  -debug ^
  -D dump=pretty ^
  -cs target\cs
set rc=%errorlevel%
popd
if not %rc% == 0 exit /b %rc%

echo Testing...
mono "%~dp0..\target\cs\bin\TestRunner-Debug.exe"
