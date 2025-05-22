#include <game/shared/ehandle.h>
#include <entity2/entitysystem.h>

// 非内联版本的实现，以防inline版本不起作用
CEntityInstance* CEntityHandle::Get() const
{
    return GameEntitySystem()->GetEntityInstance(*this);
} 