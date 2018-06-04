 # analyze_dir #
 
A Powershell simple alternative to "du |sort -n"

 ## Instructions ##

 ### Enable Powershell scripting ###
 
Run Windows console as administrator, then:

```console 
powershell set-executionpolicy remotesigned
```

 ### Run the script ###

```console 
powershell -File analyze_dir.ps1 -Path DRIVE:\PATH\TO\ANALYZE > logfile.log
```