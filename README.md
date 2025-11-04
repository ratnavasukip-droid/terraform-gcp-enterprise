# Enterprise Data Platform on GCP: A Complete Infrastructure Story

## The Journey

This project represents a complete enterprise-grade data platform built on Google Cloud Platform (GCP). Imagine building a city - you need infrastructure, utilities, security, and different zones for different purposes. That's exactly what we've built here, but for data.

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