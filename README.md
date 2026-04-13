# StarWords

# 📊 Cloud Performance Analysis

To better understand how cloud infrastructure behaves in real-world usage, I enabled **CloudFront access logging** and analyzed request data using a Python-based pipeline.

---

## 🔍 What I Measured

- Request latency (`time-taken`)
- HTTP status codes (`sc-status`)
- Error rates (4xx vs 5xx)

---

## 📈 Results

- **Average Latency:** 0.079 seconds  
- **Client Error Rate (4xx):** 42.86%  
- **Server Error Rate (5xx):** 0.00%  

---

## 🧠 Interpretation

- ⚡ **Low latency** indicates fast content delivery through CloudFront CDN  
- ✅ **Zero server-side errors (5xx)** suggests strong infrastructure reliability  
- ⚠️ **4xx errors** are primarily client-side (invalid paths, blocked access, or direct requests), not system failures  

---

## 🛠️ How It Works

1. CloudFront access logs are delivered to S3  
2. Logs are stored in compressed (`.gz`) format  
3. A Python script:
   - decompresses logs  
   - parses JSON records  
   - extracts latency and status codes  
   - computes metrics  

---

## 💡 Why This Matters

This project goes beyond building a frontend application — it demonstrates:

- Cloud observability  
- Metrics-driven analysis  
- Understanding of system reliability vs user behavior  
- Real-world performance validation using production-like data  

---

## 🚀 Next Steps

- Add DynamoDB for user progress tracking and scalability  
- Introduce API Gateway + Lambda for backend services  
- Expand analytics to measure user engagement and behavior  
- Automate analysis using CI/CD pipelines  
