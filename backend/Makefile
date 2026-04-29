.PHONY: build run test clean docker-build docker-run

# 变量
BINARY_NAME=ttlock-server
BUILD_DIR=bin
CMD_DIR=cmd/server
CONFIG_DIR=configs

# 默认目标
all: build

# 安装依赖
deps:
	@echo "安装依赖..."
	go mod download
	go mod tidy

# 构建
build: deps
	@echo "构建应用..."
	CGO_ENABLED=0 GOOS=linux go build -o $(BUILD_DIR)/$(BINARY_NAME) $(CMD_DIR)/main.go
	@echo "构建完成: $(BUILD_DIR)/$(BINARY_NAME)"

# 本地运行
run: deps
	@echo "启动服务..."
	go run $(CMD_DIR)/main.go -config $(CONFIG_DIR)/config.yaml

# 测试
test:
	@echo "运行测试..."
	go test -v ./...

# 基准测试
bench:
	@echo "运行基准测试..."
	go test -bench=. -benchmem ./...

# 测试覆盖率
coverage:
	@echo "生成测试覆盖率报告..."
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	@echo "覆盖率报告已生成: coverage.html"

# 清理
clean:
	@echo "清理构建文件..."
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html

# Docker 构建
docker-build:
	@echo "构建 Docker 镜像..."
	docker build -t $(BINARY_NAME):latest .

# Docker 运行
docker-run:
	@echo "运行 Docker 容器..."
	docker run -d \
		-p 8080:8080 \
		-v $(PWD)/$(CONFIG_DIR):/app/configs \
		--name $(BINARY_NAME) \
		$(BINARY_NAME):latest

# Docker 停止
docker-stop:
	@echo "停止 Docker 容器..."
	docker stop $(BINARY_NAME)
	docker rm $(BINARY_NAME)

# 格式化代码
fmt:
	@echo "格式化代码..."
	go fmt ./...

# 代码检查
lint:
	@echo "运行代码检查..."
	golangci-lint run

# 初始化数据库
init-db:
	@echo "初始化数据库..."
	mysql -u root -p < scripts/init_db.sql

# 帮助信息
help:
	@echo "可用命令:"
	@echo "  make build       - 构建应用"
	@echo "  make run         - 本地运行"
	@echo "  make test        - 运行测试"
	@echo "  make bench       - 基准测试"
	@echo "  make coverage    - 测试覆盖率"
	@echo "  make clean       - 清理构建文件"
	@echo "  make docker-build - 构建 Docker 镜像"
	@echo "  make docker-run   - 运行 Docker 容器"
	@echo "  make fmt         - 格式化代码"
	@echo "  make lint        - 代码检查"
	@echo "  make init-db     - 初始化数据库"
