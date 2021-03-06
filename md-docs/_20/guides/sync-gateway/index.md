---
id: sync-gateway
title: Sync Gateway
permalink: guides/sync-gateway/index.html
redirect_from:
  - guides/sync-gateway/views/index.html
  - guides/sync-gateway/resolving-conflicts/index.html
---

Sync Gateway:

- Maintains up-to-date copies of documents where users need them. On mobile devices for instant access and on servers in data centers for reasons such as synchronizing documents, sharing documents, and loss-protection. Mobile apps create, update, and delete files locally, Sync Gateway takes care of the rest.
- Provides access control, ensuring that users can only access documents to which they should have access.
- Ensures that only _relevant_ documents are synced. Sync Gateway accomplishes this by examining document and applying business logic to decide whether to assign the documents to channels. Access control and ensuring that only relevant documents are synced are achieved through the use of _channels_ and the _sync function_.