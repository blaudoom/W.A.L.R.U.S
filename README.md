# W.A.L.R.U.S
## Web Assessment Logging and Reporting ...Uh ... SYSTEM!

## !!WARNING!! This application contains several "vulnerabilities", which are left as is for streamlining the usage.
DO NOT HOST THIS APPLICATION OUTSIDE LOCALHOST!!! Unless you want to grant code execution to anyone who can access it.
- You can give free nmap commands `nmap {insert command injection here}`
- You can edit Thymeleaf templates. The version is new enough to mitigate most Java methods with system code execution, but still.
- Currently, there is no authentication. Anyone can access the application and run commands.

### What is it?
W.A.L.R.U.S is a UI for nmap. The idea is to gather cumulative information from several Nmap scans in one location. 
Many times when scanning larger networks or just wonky servers, some services appear online on some scans and not on others.
I wanted to gather this cumulative information in one view, where I can see what services have been online on different scans.

The application has no tests, no proper error handling, no proper logging, no proper documentation, no proper input sanitation, no proper anything.
It might not parse all nmap XMLs. Will add more parsing when I encounter more XMLs. Since I did not want to use the same schema for database as the XML.


### How does it work?
Its a SpringBoot application with currently a vue.js frontend. You can issue nmap scans from the UI. The scans are executed by the nmap binary configured in the settings.

### How do I use it?
- Install postgres
- Create a user and database for the application
- Run the jar or build it yourself

### How do I install it?
See above

### How do I configure it?


### Future Plans or stuff I was too lazy to do properly

- Reporting with a template
- Adding other scanning tools like nikto, dirb, gobuster, etc.
- Proper clean UI repo. This one is scraped from Vuestic Admin Template
- Proper input sanitation, if someone wants to run this to be executable remotely. Now it has straight through command execution.
- Proper logging, now it's just a print to console
- Proper error handling, now it's just a print to console
- Proper documentation, now it's just a README.md
- Proper testing, now it's just a print to console
- More Nmap options, now it's just a few. You can always use the custom command option, but all output is not parsed.
- MSF integration
- Authentication (Mostly implemented, but commented out for now)