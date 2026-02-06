@echo off
echo "Converting..."
python decompile_lua.py
python step1_convert.py
python step2_convert_dialog.py
python step3_output.py
echo "Done."