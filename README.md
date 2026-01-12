<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# 40ants-pg - A set of utilities to work with Postgresql using Mito and Common Lisp.

<a id="40-ants-pg-asdf-system-details"></a>

## 40ANTS-PG ASDF System Details

* Description: A set of utilities to work with Postgresql using Mito and Common Lisp.
* Licence: Unlicense
* Author: Alexander Artemenko <svetlyak.40wt@gmail.com>
* Homepage: [https://40ants.com/40ants-pg/][4ece]
* Bug tracker: [https://github.com/40ants/40ants-pg/issues][e36e]
* Source control: [GIT][5dfc]
* Depends on: [alexandria][8236], [bordeaux-threads][3dbf], [cl-dbi][6bc3], [cl-mustache][1dd0], [dbd-postgres][0b29], [dbi][a5c3], [ironclad][90b9], [local-time][46a1], [log4cl][7f8b], [mito][5b70], [secret-values][cd18], [serapeum][c41d], [snakes][165e], [str][ef7f], [sxql][2efd]

[![](https://github-actions.40ants.com/40ants/40ants-pg/matrix.svg?only=ci.run-tests)][4232]

![](http://quickdocs.org/badge/40ants-pg.svg)

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :40ants-pg)
```
<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Usage

`TODO`: Write a library description. Put some examples here.

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FCONNECTION-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-PG/CONNECTION

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-2240ANTS-PG-2FCONNECTION-22-29-20PACKAGE-29"></a>

#### [package](0007) `40ants-pg/connection`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FCONNECTION-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FCONNECTION-24CONNECTION-ERROR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### CONNECTION-ERROR

<a id="x-2840ANTS-PG-2FCONNECTION-3ACONNECTION-ERROR-20CONDITION-29"></a>

###### [condition](0c77) `40ants-pg/connection:connection-error` (error)

**Readers**

<a id="x-2840ANTS-PG-2FCONNECTION-3AERROR-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-PG-2FCONNECTION-3ACONNECTION-ERROR-29-29"></a>

###### [reader](0c77) `40ants-pg/connection:error-message` (connection-error) (:message)

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FCONNECTION-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-PG-2FCONNECTION-3ACONNECT-20FUNCTION-29"></a>

##### [function](26fc) `40ants-pg/connection:connect` &key host database-name username password port (cached \*cached-default\*) (application-name nil) (use-ssl :no)

<a id="x-2840ANTS-PG-2FCONNECTION-3ACONNECT-TOPLEVEL-20FUNCTION-29"></a>

##### [function](bcbe) `40ants-pg/connection:connect-toplevel`

<a id="x-2840ANTS-PG-2FCONNECTION-3ACONNECT-TOPLEVEL-IN-DEV-20FUNCTION-29"></a>

##### [function](40c6) `40ants-pg/connection:connect-toplevel-in-dev`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FCONNECTION-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-PG-2FCONNECTION-3AWITH-CONNECTION-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](800c) `40ants-pg/connection:with-connection` (&rest connect-options) &body body

Establish a new connection and start transaction

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FLOCKS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-PG/LOCKS

<a id="x-28-23A-28-2815-29-20BASE-CHAR-20-2E-20-2240ANTS-PG-2FLOCKS-22-29-20PACKAGE-29"></a>

#### [package](bf09) `40ants-pg/locks`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FLOCKS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FLOCKS-24LOCK-TIMEOUT-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOCK-TIMEOUT

<a id="x-2840ANTS-PG-2FLOCKS-3ALOCK-TIMEOUT-20CONDITION-29"></a>

###### [condition](1ba9) `40ants-pg/locks:lock-timeout` (unable-to-aquire-lock)

Raised when you are trying to get lock to was unable to do this during current lock_timeout.

**Readers**

<a id="x-2840ANTS-PG-2FLOCKS-3ALOCK-TIMEOUT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-PG-2FLOCKS-3ALOCK-TIMEOUT-29-29"></a>

###### [reader](1ba9) `40ants-pg/locks:lock-timeout` (lock-timeout) (:timeout)

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FLOCKS-24UNABLE-TO-AQUIRE-LOCK-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AQUIRE-LOCK

<a id="x-2840ANTS-PG-2FLOCKS-3AUNABLE-TO-AQUIRE-LOCK-20CONDITION-29"></a>

###### [condition](6c62) `40ants-pg/locks:unable-to-aquire-lock` (simple-error)

Signaled if some thread was unable to get a lock on a database.

**Readers**

<a id="x-2840ANTS-PG-2FLOCKS-3ALOCK-KEY-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-PG-2FLOCKS-3AUNABLE-TO-AQUIRE-LOCK-29-29"></a>

###### [reader](6c62) `40ants-pg/locks:lock-key` (unable-to-aquire-lock) (:key)

<a id="x-2840ANTS-PG-2FLOCKS-3ALOCK-NAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-PG-2FLOCKS-3AUNABLE-TO-AQUIRE-LOCK-29-29"></a>

###### [reader](6c62) `40ants-pg/locks:lock-name` (unable-to-aquire-lock) (:lock-name)

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FLOCKS-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-PG-2FLOCKS-3AWITH-LOCK-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](aef7) `40ants-pg/locks:with-lock` (name &key (block t) (timeout 3) (signal-on-failure t)) &body body

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FQUERY-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-PG/QUERY

<a id="x-28-23A-28-2815-29-20BASE-CHAR-20-2E-20-2240ANTS-PG-2FQUERY-22-29-20PACKAGE-29"></a>

#### [package](17d9) `40ants-pg/query`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FQUERY-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-PG-2FQUERY-3AALL-OBJECTS-ITERATOR-20FUNCTION-29"></a>

##### [function](94c1) `40ants-pg/query:all-objects-iterator` class &key (id-slot-getter #'object-id) (id-slot :id) (batch-size 10)

Iterates through all objects of given class fetching them in batches.

<a id="x-2840ANTS-PG-2FQUERY-3AEXECUTE-20FUNCTION-29"></a>

##### [function](f55a) `40ants-pg/query:execute` sql &rest params

<a id="x-2840ANTS-PG-2FQUERY-3ASELECT-DAO-BY-IDS-20FUNCTION-29"></a>

##### [function](b36b) `40ants-pg/query:select-dao-by-ids` CLASS-NAME IDS &KEY (ID-FIELD "id") (ID-SLOT-GETTER #'OBJECT-ID) (SQL "SELECT \* FROM {{table}} WHERE \"{{column}}\" in {{placeholders}}")

Returns `CLOS` objects with given ids.

Results are returned in the same order as was in ids list.
If some objects were not fetched, nil is returned at it's position
in the resulting list.

<a id="x-2840ANTS-PG-2FQUERY-3ASELECT-ONE-COLUMN-20FUNCTION-29"></a>

##### [function](f490) `40ants-pg/query:select-one-column` query &key binds (column :id)

<a id="x-2840ANTS-PG-2FQUERY-3ASQL-FETCH-ALL-20FUNCTION-29"></a>

##### [function](ca01) `40ants-pg/query:sql-fetch-all` sql &rest params

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FSETTINGS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-PG/SETTINGS

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-2240ANTS-PG-2FSETTINGS-22-29-20PACKAGE-29"></a>

#### [package](b194) `40ants-pg/settings`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FSETTINGS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-APPLICATION-NAME-20FUNCTION-29"></a>

##### [function](f7a9) `40ants-pg/settings:get-application-name`

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-DB-HOST-20FUNCTION-29"></a>

##### [function](87b0) `40ants-pg/settings:get-db-host`

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-DB-NAME-20FUNCTION-29"></a>

##### [function](54c5) `40ants-pg/settings:get-db-name`

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-DB-PASS-20FUNCTION-29"></a>

##### [function](9d88) `40ants-pg/settings:get-db-pass`

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-DB-PORT-20FUNCTION-29"></a>

##### [function](947a) `40ants-pg/settings:get-db-port`

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-DB-USER-20FUNCTION-29"></a>

##### [function](8f9c) `40ants-pg/settings:get-db-user`

<a id="x-2840ANTS-PG-2FSETTINGS-3AGET-DEFAULT-APPLICATION-NAME-20FUNCTION-29"></a>

##### [function](c891) `40ants-pg/settings:get-default-application-name`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FTRANSACTIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-PG/TRANSACTIONS

<a id="x-28-23A-28-2822-29-20BASE-CHAR-20-2E-20-2240ANTS-PG-2FTRANSACTIONS-22-29-20PACKAGE-29"></a>

#### [package](4c1e) `40ants-pg/transactions`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FTRANSACTIONS-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-PG-2FTRANSACTIONS-3AWITH-TRANSACTION-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](b849) `40ants-pg/transactions:with-transaction` &body body

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-4040ANTS-PG-2FUTILS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-PG/UTILS

<a id="x-28-23A-28-2815-29-20BASE-CHAR-20-2E-20-2240ANTS-PG-2FUTILS-22-29-20PACKAGE-29"></a>

#### [package](cd52) `40ants-pg/utils`

<a id="x-2840ANTS-PG-DOCS-2FINDEX-3A-3A-7C-4040ANTS-PG-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-PG-2FUTILS-3AMAKE-LIST-PLACEHOLDERS-20FUNCTION-29"></a>

##### [function](7f4f) `40ants-pg/utils:make-list-placeholders` list

Given a list of items, returns a string like "(?,?,?)"
where number of questionmarks corresponds to number of list items.

<a id="x-2840ANTS-PG-2FUTILS-3AMAP-BY-ID-20FUNCTION-29"></a>

##### [function](1cef) `40ants-pg/utils:map-by-id` dao-objects &key (id-slot-getter #'object-id) (test 'eql)


[4ece]: https://40ants.com/40ants-pg/
[5dfc]: https://github.com/40ants/40ants-pg
[4232]: https://github.com/40ants/40ants-pg/actions
[0007]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/connection.lisp#L1
[bcbe]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/connection.lisp#L120
[40c6]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/connection.lisp#L124
[800c]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/connection.lisp#L184
[0c77]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/connection.lisp#L49
[26fc]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/connection.lisp#L86
[bf09]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/locks.lisp#L1
[aef7]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/locks.lisp#L120
[6c62]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/locks.lisp#L47
[1ba9]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/locks.lisp#L64
[17d9]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/query.lisp#L1
[f490]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/query.lisp#L103
[94c1]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/query.lisp#L108
[f55a]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/query.lisp#L34
[ca01]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/query.lisp#L38
[b36b]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/query.lisp#L53
[b194]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L1
[87b0]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L18
[947a]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L22
[54c5]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L27
[8f9c]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L31
[9d88]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L35
[c891]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L40
[f7a9]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/settings.lisp#L45
[4c1e]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/transactions.lisp#L1
[b849]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/transactions.lisp#L19
[cd52]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/utils.lisp#L1
[1cef]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/utils.lisp#L13
[7f4f]: https://github.com/40ants/40ants-pg/blob/036e79ff65221db59fbdb5d30e2389855032ce43/src/utils.lisp#L23
[e36e]: https://github.com/40ants/40ants-pg/issues
[8236]: https://quickdocs.org/alexandria
[3dbf]: https://quickdocs.org/bordeaux-threads
[6bc3]: https://quickdocs.org/cl-dbi
[1dd0]: https://quickdocs.org/cl-mustache
[0b29]: https://quickdocs.org/dbd-postgres
[a5c3]: https://quickdocs.org/dbi
[90b9]: https://quickdocs.org/ironclad
[46a1]: https://quickdocs.org/local-time
[7f8b]: https://quickdocs.org/log4cl
[5b70]: https://quickdocs.org/mito
[cd18]: https://quickdocs.org/secret-values
[c41d]: https://quickdocs.org/serapeum
[165e]: https://quickdocs.org/snakes
[ef7f]: https://quickdocs.org/str
[2efd]: https://quickdocs.org/sxql

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
