-- CreateEnum
CREATE TYPE "PIGGYBANK_TYPE" AS ENUM ('REGULAR', 'EMERGENCY');

-- CreateEnum
CREATE TYPE "PIGGYBANK_TOPUP_FREQUENCY" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY');

-- CreateEnum
CREATE TYPE "TRANSACTION_TYPE" AS ENUM ('PROCESSING', 'COMPLETED', 'FAILED', 'REVERSED');

-- CreateEnum
CREATE TYPE "TRANSACTION_PURPOSE" AS ENUM ('SAVE', 'TOPUP', 'WITHDRAWAL');

-- CreateEnum
CREATE TYPE "NOTIFICATION_TYPE" AS ENUM ('ALERT', 'CONFIRMATION', 'UPDATE', 'CRITICAL');

-- CreateEnum
CREATE TYPE "SEX" AS ENUM ('FEMALE', 'MALE');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT,
    "password" TEXT NOT NULL,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "isSuperAdmin" BOOLEAN NOT NULL DEFAULT false,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profile" (
    "id" SERIAL NOT NULL,
    "userId" UUID NOT NULL,
    "lastname" TEXT NOT NULL,
    "firstname" TEXT NOT NULL,
    "middlename" TEXT,
    "age" INTEGER NOT NULL,
    "phone" INTEGER NOT NULL,
    "date_of_birth" TIMESTAMP(3) NOT NULL,
    "display_photo" TEXT,
    "country" TEXT,
    "state" TEXT,
    "city" TEXT,
    "address" TEXT,
    "sex" "SEX" NOT NULL DEFAULT 'FEMALE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PiggyBanks" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "type" "PIGGYBANK_TYPE" NOT NULL DEFAULT 'REGULAR',
    "target" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "current" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "deadline" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "isAutoTopUP" BOOLEAN NOT NULL DEFAULT false,
    "isRecurring" BOOLEAN NOT NULL DEFAULT false,
    "frequencyTopUp" "PIGGYBANK_TOPUP_FREQUENCY" NOT NULL DEFAULT 'DAILY',
    "penalty" DECIMAL(65,30) DEFAULT 0.0,
    "creatorId" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "PiggyBanks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transactions" (
    "id" UUID NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "purpose" "TRANSACTION_PURPOSE" NOT NULL DEFAULT 'SAVE',
    "status" "TRANSACTION_TYPE" NOT NULL DEFAULT 'PROCESSING',
    "comments" TEXT,
    "referenceId" TEXT,
    "fees" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "totalAmount" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "paymentMethod" TEXT,
    "reversalReason" TEXT,
    "creatorId" UUID NOT NULL,
    "piggyBankId" UUID NOT NULL,
    "initiatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notifications" (
    "id" SERIAL NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NOTIFICATION_TYPE" NOT NULL DEFAULT 'ALERT',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotificationRecipients" (
    "id" SERIAL NOT NULL,
    "notificationId" INTEGER NOT NULL,
    "userId" UUID NOT NULL,

    CONSTRAINT "NotificationRecipients_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Profile_userId_key" ON "Profile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Transactions_referenceId_key" ON "Transactions"("referenceId");

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PiggyBanks" ADD CONSTRAINT "PiggyBanks_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transactions" ADD CONSTRAINT "Transactions_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transactions" ADD CONSTRAINT "Transactions_piggyBankId_fkey" FOREIGN KEY ("piggyBankId") REFERENCES "PiggyBanks"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationRecipients" ADD CONSTRAINT "NotificationRecipients_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES "Notifications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationRecipients" ADD CONSTRAINT "NotificationRecipients_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
