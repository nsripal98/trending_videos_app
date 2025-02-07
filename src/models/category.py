from dataclasses import dataclass
from typing import Optional

@dataclass
class Category:
    id: str
    name: str
    icon: str
    color: str
    parent_id: Optional[str] = None
    description: Optional[str] = None