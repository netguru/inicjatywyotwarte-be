# frozen_string_literal: true

Crono.perform(UploadResourcesToStorageWorker).every 30.minutes
Crono.perform(UploadTagsToStorageWorker).every 2.hours
