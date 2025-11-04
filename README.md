# Enterprise Data Platform on GCP: A Complete Infrastructure Story

## The Journey: Building Our Digital Kingdom 🏰

Imagine we're building a modern digital kingdom from the ground up. This isn't just any infrastructure - it's a carefully planned, secure, and efficient data platform built on Google Cloud Platform (GCP). Let me take you through our journey of building this kingdom, where each module plays a crucial role in creating a powerful and secure data platform.

### Our Building Story 📖

When we set out to build this platform, we asked ourselves:
- How do we keep our data secure? 
- Where should we store different types of data?
- How do we process data efficiently?
- How do we make sure only the right people have access?

Let me share how we answered each of these questions through our modules, explaining exactly what we built and why we made each choice.

## 📦 Our Kingdom's Components: A Detailed Tour

### 1. The Foundation: Project Module (`project/`)
Imagine getting the deed to your land and necessary building permits. That's what our project module does!

**What We Built:**
- Created a unique project ID with a random suffix for global uniqueness
- Set up a dedicated billing account to track all costs
- Enabled all necessary Google APIs (like getting utilities connected)
- Created a special "service account" (think of it as our trusted royal builder)

**Why We Built It This Way:**
- Projects in GCP must have globally unique names (like having a unique address)
- We need billing set up to create resources (like having a bank account for construction)
- APIs need to be enabled before use (like getting permits for different types of construction)
- Service accounts help automate tasks securely (like having a trusted contractor)

**Real-World Benefits:**
- Easy cost tracking per environment (dev/staging/prod)
- Clear organization of resources
- Automated setup that prevents human error
- Secure foundation for all other resources

### 2. The Royal Vault: Storage Module (`storage/`)
Think of this as building different types of vaults in our kingdom, each with its own special purpose.

**What We Built:**
1. **Raw Data Vault** (`raw-data` bucket):
   - First stop for all incoming data
   - Automatically moves data to cheaper storage after 30 days
   - Uses encryption for security
   - Like a receiving dock that automatically organizes items

2. **Processed Data Vault** (`processed-data` bucket):
   - Stores cleaned and transformed data
   - Keeps frequently accessed data readily available
   - Moves to cheaper storage after 60 days
   - Like a well-organized library where everything is easy to find

3. **Archives** (`archive` bucket):
   - Long-term storage vault
   - Uses cheapest storage option
   - Perfect for data we rarely need but must keep
   - Like a secure basement archive

4. **Royal Records** (`logs` bucket):
   - Keeps system logs for 90 days
   - Automatically deletes old logs
   - Like having a detailed diary of everything that happens

**Why We Built It This Way:**
- Different storage classes save money (like having different types of storage rooms)
- Encryption keeps data safe (like having vault locks)
- Lifecycle rules automatically organize data (like having smart shelves)
- Version control prevents accidents (like having backups)

**Real-World Benefits:**
- Cost optimization through automatic storage management
- Enhanced security with encryption
- No manual maintenance needed
- Compliance-ready with retention policies

### 3. The Royal Library: BigQuery Module (`bigquery/`)
Imagine a magical library where librarians can instantly find any piece of information in millions of books. That's our BigQuery setup!

**What We Built:**
1. **Raw Data Library** (Dataset):
   - Initial storage for all data
   - Temporary home (90-day retention in development)
   - Like a receiving area for new books

2. **Analytics Library** (Dataset):
   - Clean, organized data ready for analysis
   - Optimized for quick access
   - 1-year retention policy
   - Like having books perfectly categorized and indexed

3. **Machine Learning Collection** (Dataset):
   - Specially prepared data for AI/ML
   - No automatic deletion
   - Like a special collection for research

**Why We Built It This Way:**
- Separate datasets for different purposes (like different sections in a library)
- Retention policies to manage costs
- Encryption for sensitive data
- Optimized for both storage and quick analysis

**Real-World Benefits:**
- Query terabytes of data in seconds
- Pay only for the queries you run
- No servers to manage
- Perfect for data scientists and analysts

### 4. The Royal Orchestra: Composer Module (`composer/`)
Think of this as having a master conductor who orchestrates all the activities in our kingdom perfectly.

**What We Built:**
- A fully managed Apache Airflow environment
- Private network setup for security
- Integration with other services
- Automated backup and recovery
- Custom service account with specific permissions

**Why We Built It This Way:**
- Airflow is perfect for complex data workflows
- Private network keeps operations secure
- Automated backups prevent data loss
- Custom permissions ensure proper access

**Real-World Benefits:**
- Schedule complex data pipelines
- Automate repetitive tasks
- Monitor workflow success/failure
- Easily retry failed operations
- Scale resources automatically

**Example Use Cases:**
1. Daily data imports from multiple sources
2. Complex ETL processes
3. Machine learning pipeline orchestration
4. Scheduled report generation

### 5. GKE Module (`gke/`)
Think of it as a smart factory for running applications:
- **What it is**: Google's service for running containerized apps
- **Why we need it**: To run applications that can scale automatically
- **How it helps**:
  - Runs applications reliably
  - Grows or shrinks based on demand
  - Manages everything automatically

### 6. IAM Module (`iam/`)
Like a sophisticated security system:
- **What it is**: Controls who can access what
- **Why we need it**: To keep resources secure
- **How it helps**:
  - Manages access permissions
  - Prevents unauthorized access
  - Maintains security compliance

### 7. The Royal Key Master: KMS Module (`kms/`)
Think of this as your kingdom's master locksmith who creates and manages all the special keys that protect your treasures.

**What We Built:**
1. **Key Ring**:
   - A secure container for all encryption keys
   - Regional deployment for better security
   - Like a master key cabinet

2. **Storage Encryption Key**:
   - Special key for Cloud Storage buckets
   - Automatically rotates every 90 days
   - Uses Google's strongest encryption algorithm
   - Like having self-changing vault locks

3. **BigQuery Encryption Key**:
   - Dedicated key for data warehouse
   - Same strong security features
   - Like having special locks for the library

**Why We Built It This Way:**
- Regular key rotation (every 90 days) for security
- Different keys for different services
- Customer-managed for complete control
- High-security protection level

**Real-World Benefits:**
- Meet compliance requirements
- Protect sensitive data
- Control who can access encrypted data
- Automatic key management

### 8. Networking Module (`networking/`)
Like designing the road system of a city:
- **What it is**: Sets up your cloud network
- **Why we need it**: To connect all resources securely
- **How it helps**:
  - Creates private networks
  - Controls traffic flow
  - Keeps resources secure

### 9. Logging Module (`logging/`)
Like having security cameras and record-keeping:
- **What it is**: Tracks everything happening in your system
- **Why we need it**: To monitor and troubleshoot
- **How it helps**:
  - Records system activities
  - Helps find and fix problems
  - Maintains audit records

## 🏗 The Architecture Story

### 1. Foundation (`project` module)
Just like building a house starts with laying the foundation, our data platform starts with the project module:
- Creates a new GCP project with a unique ID
- Enables all necessary Google APIs
- Sets up a service account (think of it as our trusted contractor)
- Configures basic IAM roles (like giving keys to the right people)

### 2. Security First (`kms` module)
Before we store any data, we need to ensure it's secure:
- Creates a key ring (like a secure key cabinet)
- Sets up two types of encryption keys:
  - Storage Key: For encrypting files in Cloud Storage
  - BigQuery Key: For encrypting data in BigQuery
- Configures automatic key rotation every 90 days
- All keys use the GOOGLE_SYMMETRIC_ENCRYPTION algorithm

### 3. Data Lake (`storage` module)
Like a city needs different types of storage facilities, our platform has four specialized buckets:
- **Raw Data Bucket**: 
  - The landing zone for new data
  - Automatically moves data to cheaper storage after 30 days
  - Like a receiving dock for all incoming data
- **Processed Data Bucket**: 
  - Stores cleaned and transformed data
  - Moves to cheaper storage after 60 days
  - Think of it as a warehouse for organized goods
- **Archive Bucket**: 
  - Long-term storage for historical data
  - Uses ARCHIVE storage class for cost optimization
  - Like a secure long-term storage facility
- **Logs Bucket**: 
  - Keeps system and application logs
  - 90-day retention policy
  - Like a library of security camera footage

### 4. Data Warehouse (`bigquery` module)
Similar to how a city has different districts, our data warehouse has specialized zones:
- **Raw Data Dataset**: 
  - Initial landing zone for data
  - Mirrors the structure of incoming data
  - 90-day table expiration in development
- **Analytics Dataset**: 
  - Clean, business-ready data
  - Optimized for reporting and analysis
  - 365-day retention policy
- **ML Features Dataset**: 
  - Prepared data for machine learning
  - No expiration for training data consistency
  - Think of it as a specialized research district

### 5. Processing Power (`composer` and `gke` modules)
Like a city needs power plants and factories, our platform needs processing power:

#### Cloud Composer (Airflow):
- Orchestrates all data workflows
- Runs in its own private network
- Uses customer-managed encryption keys
- Perfect for scheduling and running data pipelines

#### Google Kubernetes Engine (GKE):
- Provides scalable compute power
- Runs in a dedicated subnet
- Uses workload identity for security
- Great for running data processing jobs

### 6. Networking (`networking` module)
Just like a city needs roads and zones, our platform needs a proper network:
- Creates a custom Virtual Private Cloud (VPC)
- Sets up separate subnets for:
  - GKE cluster
  - Cloud Composer
- Configures firewall rules
- Enables private Google access

### 7. Logging and Monitoring (`logging` module)
Like a city's surveillance system:
- Captures all system logs
- Tracks:
  - Data access logs
  - Security events
  - System operations
  - BigQuery queries
- Stores everything in a dedicated logging dataset

## 🔐 Security Features

Think of our security like layers of a secure building:
1. **Outer Layer**: Custom VPC with firewall rules
2. **Access Control**: IAM roles and service accounts
3. **Data Protection**: Customer-managed encryption keys
4. **Monitoring**: Comprehensive audit logging
5. **Network Security**: Private Google Access enabled

## 💡 The Smart Parts

1. **Cost Optimization**:
   - Automatic storage class transitions
   - Table expiration policies
   - Appropriate service sizing

2. **Security Best Practices**:
   - Least privilege access
   - Encryption everywhere
   - Network isolation

3. **Scalability**:
   - Auto-scaling GKE clusters
   - BigQuery's serverless nature
   - Cloud Composer's managed service

## 🚀 Getting Started

### Prerequisites
- GCP Account with billing enabled
- Required permissions
- `gcloud` CLI installed
- Terraform >= 1.5.0

### Deployment Steps
1. Choose your environment:
   ```bash
   cd environments/dev  # or stage/prod
   ```

2. Initialize:
   ```bash
   terraform init
   ```

3. Deploy:
   ```bash
   terraform apply
   ```

## 📈 What You Get

After deployment, you'll have:
- A fully secured data lake
- An enterprise data warehouse
- Automated data processing capabilities
- Complete logging and monitoring
- All with industry best practices for security and scalability

## 🤝 Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📝 License

This project is proprietary and confidential.

---
Built with ❤️ for data engineers, by data engineers.