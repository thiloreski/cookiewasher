# cookiewasher
The cookie pattern washer implements the idea of defining pattern to remove unwanted cookies.

Examples:
1. Delete all cookies which haven't been touched for 3 days.
2. Delete all cookies that expire not earlier than next month.
3. Despite the above two rules, keep all cookies which concern session login information until at least 30 mins after creationtime.

So create blackist patterns (no 1 and no 2 above) plus (dominating) whitelist pattern (no 3 above).

Easyest implementation is to have the black list and the white list as sqlite DB.

Specification of BWL-DB (Black and White List sqlite DB) :

For each attribute in the cookies DB, have an attribute in the BWL. 

For text attributes, entries correspond to sql matching (% - all, i.e. no contstraint, %xxx - suffix xxx, etc)

Numeric values (e.g. dates) and addtional attribute that says "earlier", "later" resp. lt, gt, eq 

Complete List of attributes:
1) execute - yes/no     # used to comment entry out 
2) id - id              # to better sort and group
3) action - delete, keep
4) -8) baseDomain, originAttribure, name, value, host, path # match baseDomain from cookie DB (% operator applies)
9) -14) for expiry, lastAccessed, creationTime: 
   two columns each, first for a time diff (e.h. '+3 days'), second for relation: later, earlier
    
   examnple : fire for all cookies older that 10 days: created earliert than 10 day back

   creationTime value: "-10" relation to creationTime value: "earlier"
   simple rule:
       add value to today ('now') if date in cooke DB is 'relation' then fire
       i.e. today + (-10) - earlier => all cookies which have been created ealiert than 10 days ago
   
15) -18) isSecure, isHttpOnly, Browserelement, sameSite - match


After working with the BWL, I found out that the most challenging issue is to define what I want.
I came up with this:

a) I want to keep all cookies related to session user login or value if it has been accessed less than 30 mins ago. This should be tackled different on different web-sites(different user names....)

b) all other cookies are just kept 10 mins after creation

c) exemptions to b) are in the whitelist

Hint:
How-to create a list of cookies from wanted or unwanted domains:

select baseDomain from coo.moz_cookies; > file

export moz_bwl to csv, put file into same csv and import

Current state:
I wrapped a shell script around the plain SQL to give hints, do some Backup etc.

Installation: Copy all this in a seperated dir, adapt the path in the shell script, end FF.
Then unpack, copy the cookie-DB, usually (linux) sth like: /home/<user_name>/.mozilla/firefox/<some_random_id>.<user_name>
from FF to local dir and run FF_cookie_pattern_washer.sh

Watch output

TODO: Integrate into FF and execute repeatedly
