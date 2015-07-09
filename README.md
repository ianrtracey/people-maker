# People Maker

A generator to help developers build sample databases for their graph databases.
(Currently being implemented for the Neo4j graph database importer)

## Installation
1. git clone https://github.com/ianrtracey/people-maker.git 
2. gem install bundler (if not already installed)
3. bundle install
4. Edit the path **DB=${1-/your-neo4j-path-here}** in **importer/import-mvn.sh** to your Neo4j installation path
	
## Usage
* **ruby run.rb generate** *(generates sample data)*
* **ruby run.rb import** *(imports sample data)*
* **ruby run.rb generate import** *(generates and imports sample data)* 


View Full Batch Import Project
https://github.com/jexp/batch-import

